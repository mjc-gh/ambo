# frozen_string_literal: true

require 'test_helper'

class AmboContextsTwitterTest < Minitest::Test
  setup do
    @context = Ambo::Context.new('test_bot')
  end

  teardown { teardown_twitter_env! }

  test 'tweet_as without env vars' do
    assert_raises Ambo::LoaderError do
      @context.tweet_as 'foo'
    end
  end

  test 'tweet_as with env vars' do
    setup_twitter_env!

    @context.tweet_as 'foo'

    assert_equal 'a', @context.config.dig(:twitter, :consumer_key)
    assert_equal 'b', @context.config.dig(:twitter, :consumer_secret)
    assert_equal 'c', @context.config.dig(:twitter, :access_token)
    assert_equal 'd', @context.config.dig(:twitter, :access_token_secret)
  end
end
