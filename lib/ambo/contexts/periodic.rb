module Ambo
  class Context
    module Periodic
      # @param min [ActiveSupport::Duration, Integer] minimum time to wait before next message
      # @param max [ActiveSupport::Duration, Integer] maximum time to wait before next message
      # @param repeat_after [Integer] number of messages before a new message can be repeated
      # @return [Ambo::Context] self
      def every(min, max = nil, repeat_after: nil)
        config.every = {}

        if max.nil?
          config.every[:delay] = validate(min_duration)
        else
          config.every.update(min: validate(min), max: validate(max))
        end

        config.every[:repeat_after] = repeat_after unless repeat_after.nil?
      end

      # @yield [last_message] A block that is called to generate the next message
      # @yieldparam [Message] last message sent, if any
      def next_message(&block)
        config.on_next_message = block
      end

      # @return [TrueClass, FalseClass] check if periodic is setup
      def periodic?
        config.respond_to? :every
      end

      private

      def validate(duration) # :nodoc:
        case duration
        when ActiveSupport::Duration, Integer then duration.seconds
        else
          raise LoaderError.new "Invalid duration: #{duration.inspect}; "/
            'must be ActiveSupport::Duration or Integer'
        end
      end
    end
  end
end
