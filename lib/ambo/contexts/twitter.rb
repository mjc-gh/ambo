# frozen_string_literal: true

module Ambo
  class Context
    # Context methods for defining bots that send messages to Twitter.
    module Twitter
      CLIENT_CONFIG = %i[
        consumer_key consumer_secret access_token access_token_secret
      ].freeze

      # @param [String] Twitter username string; the API key ENV variable
      #                 is inferred from this name
      # @example Send messages via Twitter
      #   tweet_as 'MyTwtrBot' # uses ENV["TWITTER_MY_TWTR_BOT_API_KEY"]
      def tweet_as(username)
        @env_key_prefix = "TWITTER_#{username.underscore.upcase}"

        config.twitter = CLIENT_CONFIG.each.with_object({}) do |key, memo|
          memo[key] = ENV.fetch(env_key_for(key))
        end
      rescue KeyError => e
        raise LoaderError, "ENV variable missing; #{e}"
      end

      # @return [TrueClass, FalseClass] check if Twitter is setup
      def twitter?
        config.respond_to? :twitter
      end

      private

      def env_key_for(type)
        "#{@env_key_prefix}_#{type.to_s.underscore.upcase}"
      end
    end
  end
end
