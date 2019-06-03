# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ambo'

require 'minitest/autorun'

module Minitest
  class Test
    def self.test(name, &block)
      define_method "test_#{name.gsub(/\s+/, '_')}", &block
    end

    def self.setup(&block)
      define_method :setup, &block
    end

    def self.teardown(&block)
      define_method :teardown, &block
    end

    def setup_twitter_env!
      ENV['TWITTER_FOO_CONSUMER_KEY'] = 'a'
      ENV['TWITTER_FOO_CONSUMER_SECRET'] = 'b'
      ENV['TWITTER_FOO_ACCESS_TOKEN'] = 'c'
      ENV['TWITTER_FOO_ACCESS_TOKEN_SECRET'] = 'd'
    end

    def teardown_twitter_env!
      ENV.delete 'TWITTER_FOO_CONSUMER_KEY'
      ENV.delete 'TWITTER_FOO_CONSUMER_SECRET'
      ENV.delete 'TWITTER_FOO_ACCESS_TOKEN'
      ENV.delete 'TWITTER_FOO_ACCESS_TOKEN_SECRET'
    end
  end
end
