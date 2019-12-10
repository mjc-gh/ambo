# frozen_string_literal: true

module Ambo
  module Tasks
    class BaseTask
      def initialize(options, state, &block)
        @options = options
        @state   = state
        @block   = block
      end
    end
  end
end
