# frozen_string_literal: true

module Ambo
  class Runner
    # Used by Runner to encapsulate a bot's [Ambo::Content] and [Ambo::State]
    class Instance
      def initialize(ctx, state, outbound_pool)
        @context       = ctx
        @config        = ctx.config
        @deliveries    = []
        @outbound_pool = outbound_pool
        @state         = state
        @tasks         = []
      end

      def run
        setup_tasks
        setup_deliveries
      end

      def shutdown!
        @tasks.map(&:cancel)
        @deliveries
      end

      private

      def setup_tasks
        create_periodic_every_task if periodic_every?
        create_periodic_on_at_task if periodic_on_at?
      end

      def create_periodic_every_task
        @tasks << Tasks::Periodic::Every.new(@config.every, @state) do
          send_next_message
        end
      end

      def create_periodic_on_at_task
        @tasks << Tasks::Periodic::OnAt.new(@config.on, @config.at, @state) do
          send_next_message
        end
      end

      def send_next_message
        return if @outbound_pool.shuttingdown?

        @outbound_pool << proc do
          msg_txt = @config.on_next_message.call

          @state << msg_txt
          @deliveries.each { |dlvr| dlvr.send msg_txt }
        end
      end

      def setup_deliveries
        create_twitter_delivery if twitter_deliveries?
      end

      def create_twitter_delivery
        @deliveries << Ambo::Deliveries::Twitter.new(@config.twitter)
      end

      def periodic_every?
        @config.every.present?
      end

      def periodic_on_at?
        @config.on.present? || @config.at.present?
      end

      def twitter_deliveries?
        @config.twitter.present?
      end
    end
  end
end
