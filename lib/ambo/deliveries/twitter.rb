# frozen_string_literal: true

module Ambo
  module Deliveries
    # This class is responsible for deliverying messages to Twitter
    # using the {Twitter::REST::Client} class.
    class Twitter
      include Loggable

      def initialize(twitter_config)
        if self.class.twitter_installed?
          @client = ::Twitter::REST::Client.new do |config|
            config.consumer_key = twitter_config[:consumer_key]
            config.consumer_secret = twitter_config[:consumer_secret]
            config.access_token = twitter_config[:access_token]
            config.access_token_secret = twitter_config[:access_token_secret]
          end
        else
          fatal_log 'Install the twitter gem to use this feature'

          @client = NullClient.new
        end
      end

      def send(msg_txt)
        info_log "Sending message to twitter; message=#{msg_txt.inspect}"

        # @client.update msg_txt
      end

      def self.twitter_installed?
        defined? ::Twitter
      end

      # Tiny "null" class with a noop {NullClient#update} method. Able to avoid
      # conditionals in {Ambo::Deliveries::Twitter#send}.
      class NullClient
        def update; end
      end
    end
  end
end
