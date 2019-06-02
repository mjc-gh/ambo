# frozen_string_literal: true

module Ambo
  module Tasks
    # Small utility class for creating periodic tasks that automatically
    # reschedule themselves. Internally, this class uses the
    # {Concurrent::ScheduledTask} class.
    class Periodic
      include Loggable

      def initialize(options, state, &block)
        @options = options
        @block = block

        @last_sent = state.last_sent

        schedule!
      end

      def cancel
        @current_task&.cancel
      end

      private

      def schedule!
        delay = scheduled_delay

        debug_log "Scheduling task with #{delay} second delay"

        @current_task = Concurrent::ScheduledTask.execute(delay) do
          invoke_task
        end
      end

      def invoke_task
        @block.call
      rescue StandardError => e
        fatal_log "Task failed: #{e.message} (#{e.class})"
        fatal_log e.backtrace.join("\n")
      else
        debug_log 'Task successful'
      ensure
        @last_sent = Time.now

        schedule!
      end

      def scheduled_delay
        delay = configured_delay - (Time.now.to_i - @last_sent.to_i)
        delay.negative? ? 0 : delay
      end

      def configured_delay
        if @options.key? :delay then @options[:delay].to_i
        else rand(@options[:min]..@options[:max]).to_i
        end
      end
    end
  end
end
