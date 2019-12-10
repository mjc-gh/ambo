# frozen_string_literal: true

module Ambo
  module Tasks
    # Makes a Task class "schedulable" for future runs. Expects a @block
    # instance variable to be defined.
    module Schedulable
      def initialize(*)
        super

        schedule!
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
        after_task_invoked
      end

      def after_task_invoked
        super if defined? super

        schedule!
      end
    end
  end
end
