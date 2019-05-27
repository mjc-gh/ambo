module Ambo
  module Loggable
    extend ActiveSupport::Concern

    included do
      progname self.name
    end

    class_methods do
      def progname(name = nil)
        @progname = name[6..-1] if name
        @progname
      end
    end

    %w(debug info warn error fatal unknown).each do |method|
      class_eval <<-RUBY_EVAL
        def #{method}_log(message)
          Ambo.logger.#{method}(self.class.progname) { message }
        end
      RUBY_EVAL
    end
  end
end
