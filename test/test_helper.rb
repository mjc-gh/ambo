# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ambo'

require 'minitest/autorun'
require 'timecop'

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

    def redis
      @redis ||= Redis.new(url: 'redis://localhost:6379/13')
    end

    def clear_state!
      @redis.keys('ambo:*').each { |key| redis.del key }
    end

    def fixture_path
      File.join(File.expand_path(__dir__), 'fixtures')
    end

    def assert_time_of_day(actual, hour:, min: 0, sec: 0, period: 1)
      hour /= 2 if period == 2

      expected_time_str = [
        hour, min, sec
      ].map { |n| n.to_s.ljust(2, '0') }.join(':')

      expected_time_str << '.000000'

      assert_equal expected_time_str, actual.to_time_s
    end
  end
end
