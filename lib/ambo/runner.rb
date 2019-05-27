module Ambo
  class Runner
    include Loggable

    def initialize
      @contexts = []
      @deliveries = []
      @tasks = []

      @outbound_pool = Ambo::Task.create_pool
    end

    # @param [Ambo::Context] ctx Add new Bot context to the runner
    def <<(ctx)
      config = ctx.config

      @tasks << create_periodic_task(config) if ctx.periodic?
      @deliveries << create_twitter_delivery(config.twitter) if ctx.twitter?

      self
    end

    # Called by the main thread; will block until shutdown
    def wait_until_exit!
      trap_signals!

      until @outbound_pool.wait_for_termination(5)
        debug_log Ambo.random_beep_boops
      end
    end

    private

    def create_twitter_delivery(twitter_config)
      Ambo::Deliveries::Twitter.new(twitter_config)
    end

    def create_periodic_task(config)
      Ambo::Tasks::Periodic.new(config.every) do
        next if @outbound_pool.shuttingdown?

        @outbound_pool << proc { delivery_message(&config.on_next_message) }
      end
    end

    def delivery_message
      msg_txt = yield

      @deliveries.each { |dlvr| dlvr.send msg_txt }
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
