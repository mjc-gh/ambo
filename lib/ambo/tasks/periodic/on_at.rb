# frozen_string_literal: true

module Ambo
  module Tasks
    module Periodic
      # Small utility class for creating periodic tasks that automatically
      # reschedule themselves. Internally, this class uses the
      # {Concurrent::ScheduledTask} class.
      class OnAt
        prepend Cancelable
        prepend Schedulable

        include Loggable

        def initialize; end
      end
    end
  end
end
