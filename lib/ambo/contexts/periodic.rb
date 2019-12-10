# frozen_string_literal: true

module Ambo
  module Contexts
    # Context methods for defining bots with Periodic functionality.
    module Periodic
      DAYS_OF_WEEK = %i[
        monday tuesday wednesday thursday friday saturday sunday
      ].freeze

      # @param min [ActiveSupport::Duration, Integer] minimum time to wait
      #   before next message.
      # @param max [ActiveSupport::Duration, Integer] maximum time to wait
      #   before next message.
      # @return [Ambo::Context] self
      def every(min, max = nil)
        config.every = {}

        if max.nil?
          config.every[:delay] = validate_every(min)
        else
          config.every.update(
            min: validate_every(min), max: validate_every(max)
          )
        end
      end

      # Calling this method with the {#at} method is how one or more specific
      # times of day are set. If no time of day is set, midnight will be used.
      #
      # @param days_of_week [Array<String, Symbol>] *args one or more "time of
      #   day" string. These week. Days of the week should be either the full
      #   name or the day or the first 3 characters.
      # @example Send a message on Monday and Friday
      #   on 'Monday', 'Friday'
      def on(*days_of_week)
        config.on = days_of_week.map { |dow| validate_on(dow) }
      end

      # Calling this method with the {#on} will limit the days of the week the
      # message is sent.
      #
      # @param [Array<String, Symbol>] *args one or more "time of day" string.
      #   These strings should be parsable by the {Fugit} gem. See
      #   {Fugit.parse_at} for more details on valid formats.
      # @example Send message at 12:30pm
      #   at '12:30pm'
      # @example Send messages at start and end of work hours
      #   at '10am', '6pm'
      def at(*times_of_day)
        config.at = times_of_day.map { |tod| Fugit.parse_at tod }
      end

      # @param num_of_msgs [Integer] number of messages before a message
      #   can be repeated by the {next_message} block
      def repeat_after(num_of_msgs)
        config.repeat_after = validate_repeat_after(num_of_msgs)
      end

      # @yield [last_message] A block that is called to generate the next
      #   message
      # @yieldparam [Message] last message sent, if any
      def next_message(&block)
        config.on_next_message = block
      end

      private

      def validate_every(duration) # :nodoc:
        case duration
        when ActiveSupport::Duration then duration.seconds.to_i
        when Integer then duration
        else
          raise LoaderError, "Invalid duration: #{duration.inspect}; "\
            'must be ActiveSupport::Duration or Integer'
        end
      end

      def validate_on(input_dow) # :nodoc:
        dow = input_dow.downcase.to_sym
        dow = DAYS_OF_WEEK.find { |d| dow == d || dow == d[0, 3].to_sym }

        return dow if dow

        raise LoaderError, "Invalid day of week: #{input_dow.inspect}; "\
          "must be Symbol for day of week name (#{DAYS_OF_WEEK.inspect})"
      end

      def validate_repeat_after(repeat_after)
        return repeat_after if Integer === repeat_after

        raise LoaderError, 'repeat_after must be an Integer'
      end
    end
  end
end
