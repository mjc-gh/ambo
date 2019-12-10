# frozen_string_literal: true

module Ambo
  # This class is responsible for running and managing all bots. The
  # {wait_until_exit!} method is called by the {Ambo::Loader} class.
  #
  # This class will also setup signal handlers for SIGINT and SIGTERM. Both
  # signals are trapped in order to gracefully shutdown the bots.
  class Runner
    include Loggable

    def initialize
      @instances     = []
      @outbound_pool = Ambo::Task.create_pool
    end

    # @param [Ambo::Context] ctx Add new Bot context to the runner
    def <<(ctx)
      state = State.new(ctx, redis_state_pool)

      instance = Instance.new(ctx, state, @outbound_pool)
      instance.run

      @instances << instance

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

    def redis_state_pool
      @redis_pool = ConnectionPool.new(size: 5, timeout: 5) do
        Redis.new(url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/12' })
      end
    end

    def shutdown!
      info_log 'Shutting down bot runner'

      @instances.map(&:shutdown!)
      @outbound_pool.shutdown
    end

    def trap_signals!
      Signal.trap(:INT) { Thread.new { shutdown! } }
      Signal.trap(:TERM) { Thread.new { shutdown! } }
    end
  end
end
