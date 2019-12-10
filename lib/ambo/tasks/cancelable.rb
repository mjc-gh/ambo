# frozen_string_literal: true

module Ambo
  module Tasks
    # Allows a Task class to be canceled. Expects a current_task instance
    # variable to be defined.
    module Cancelable
      def cancel
        @current_task&.cancel
      end
    end
  end
end
