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

  test 'periodic on with single day of week' do
    @context.on :friday

    assert_equal %i[friday], @context.config[:on]
  end

  test 'periodic on with single short name day of week' do
    @context.on :tue

    assert_equal %i[tuesday], @context.config[:on]
  end

  test 'periodic on with multiple days of week' do
    @context.on %i[tue Wednesday sunday]

    assert_equal %i[tuesday wednesday sunday], @context.config[:on]
  end

  test 'periodic on with multiple days of week as strings' do
    @context.on %w[Mon Thursday friday]

    assert_equal %i[monday thursday friday], @context.config[:on]
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
