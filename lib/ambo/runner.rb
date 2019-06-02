# frozen_string_literal: true

module Ambo
  # This class is responsible for running and managing all bots. The
  # {wait_until_exit!} method is called by the {Amob::Loader} class.
  #
  # This class will also setup signal handlers for SIGINT and SIGTERM. Both
  # signals are trapped in order to gracefully shutdown the bots.
  class Runner
    include Loggable

    def initialize
      @deliveries = []
      @tasks = []

      @store = Store.new
      @outbound_pool = Ambo::Task.create_pool
    end

    # @param [Ambo::Context] ctx Add new Bot context to the runner
    def <<(ctx)
      state = @store.load_or_create(ctx)

      create_periodic_task(ctx, state) if ctx.periodic?
      create_twitter_delivery(ctx) if ctx.twitter?

      self
    end

    # Called by the main thread; will block until shutdown
    def wait_until_exit!
      trap_signals!

      until @outbound_pool.wait_for_termination(60)
        debug_log Ambo.random_beep_boops
      end
    end

    private

    def create_twitter_delivery(ctx)
      @deliveries << Ambo::Deliveries::Twitter.new(ctx.config.twitter)
    end

    def create_periodic_task(ctx, state)
      @tasks << Ambo::Tasks::Periodic.new(ctx.config.every, state) do
        next if @outbound_pool.shuttingdown?

        @outbound_pool << proc do
          delivery_message(ctx, &ctx.config.on_next_message)
        end
      end
    end

    def delivery_message(ctx)
      msg_txt = yield

      update_state ctx, msg_txt

      @deliveries.each { |dlvr| dlvr.send msg_txt }
    end

    def update_state(ctx, msg_txt)
      state = @store.load_or_create(ctx)
      state << msg_txt

      @store.save(ctx, state)
    end

    def shutdown!
      info_log 'Shutting down bot runner'

      @tasks.map(&:cancel)
      @outbound_pool.shutdown
    end

    def trap_signals!
      Signal.trap(:INT) { Thread.new { shutdown! } }
      Signal.trap(:TERM) { Thread.new { shutdown! } }
    end
  end
end
