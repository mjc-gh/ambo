# frozen_string_literal: true

module Ambo
  module Tasks
    module Periodic
      # Small utility class for creating periodic tasks that automatically
      # reschedule themselves. Internally, this class uses the
      # {Concurrent::ScheduledTask} class.
      class Every < BaseTask
        prepend Cancelable
        prepend Schedulable

        include Loggable

        private

        def after_task_invoked
          @last_sent = Time.now

          schedule!
        end

        def scheduled_delay
          delay = configured_delay
          delay -= Time.now.to_i - @last_sent.to_i unless @last_sent.nil?
          delay.negative? ? 0 : delay
        end

        def configured_delay
          @options.fetch(:delay) { rand(@options[:min]..@options[:max]) }
        end
      end
    end
  end
end
