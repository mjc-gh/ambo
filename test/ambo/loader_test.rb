# frozen_string_literal: true

require 'test_helper'

class AmboLoaderTest < Minitest::Test
  setup do
    setup_twitter_env!

    @runner_mock = Minitest::Mock.new
  end

  teardown { teardown_twitter_env! }

  test '#load! evals each file and calls wait_until_exit!' do
    loader = Ambo::Loader.new(fixture_path)
    loader.instance_variable_set(:@runner, @runner_mock)

    @runner_mock.expect(:<<, nil) do |ctx|
      assert_instance_of Ambo::Context, ctx
      assert_equal 'example', ctx.bot_name
    end

    @runner_mock.expect(:<<, nil) do |ctx|
      assert_instance_of Ambo::Context, ctx
      assert_equal 'example_2', ctx.bot_name
    end

    @runner_mock.expect :wait_until_exit!, nil

    loader.load!

    @runner_mock.verify
  end
end
