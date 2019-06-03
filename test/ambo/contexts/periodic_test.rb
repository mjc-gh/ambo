# frozen_string_literal: true

require 'test_helper'

class AmboContextsPeriodicTest < Minitest::Test
  setup do
    @context = Ambo::Context.new('test_bot')
  end

  test 'periodic every with fixed time integer' do
    @context.every 4

    assert_equal 4, @context.config.dig(:every, :delay)
  end

  test 'periodic every with fixed duration' do
    @context.every 10.seconds

    assert_equal 10, @context.config.dig(:every, :delay)
  end

  test 'periodic every with random interval' do
    @context.every 2, 4

    assert_equal 2, @context.config.dig(:every, :min)
    assert_equal 4, @context.config.dig(:every, :max)
  end

  test 'periodic every with random duration interval' do
    @context.every 10.seconds, 20.seconds

    assert_equal 10, @context.config.dig(:every, :min)
    assert_equal 20, @context.config.dig(:every, :max)
  end

  test 'periodic every with random mixed interval' do
    @context.every 1.seconds, 4

    assert_equal 1, @context.config.dig(:every, :min)
    assert_equal 4, @context.config.dig(:every, :max)
  end

  test 'next_message callback' do
    @context.next_message {}

    assert_instance_of Proc, @context.config[:on_next_message]
  end

  test 'periodic? when not configured' do
    @context.config.compile_methods!

    refute @context.periodic?
  end

  test 'periodic? when configured' do
    @context.every 5
    @context.config.compile_methods!

    assert @context.periodic?
  end
end
