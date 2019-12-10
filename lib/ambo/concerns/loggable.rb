# frozen_string_literal: true

module Ambo
  # Small Concern module for making it easy write to the framework logger.
  module Loggable
    extend ActiveSupport::Concern

    included do
      self.progname = name
    end

    class_methods do
      attr_reader :progname

      def progname=(name)
        @progname = name[6..-1]
      end
    end

    %w[debug info warn error fatal unknown].each do |method|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{method}_log(message)
          Ambo.logger.#{method}(self.class.progname) { message }
        end
      RUBY_EVAL
    end
  end
end
