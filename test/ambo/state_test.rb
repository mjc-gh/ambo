# frozen_string_literal: true

require 'test_helper'

class AmboStateTest < Minitest::Test
  setup do
    @state ||= begin
                 ctx = Ambo::Context.new('test')
                 pool = ConnectionPool.new(size: 1) { redis }

                 Ambo::State.new(ctx, pool, history_limit: 10)
               end
  end

  teardown { clear_state! }

  test 'add to history' do
    @state << 'async' << 'media'

    history = @redis.lrange('ambo:test:history', 0, -1)

    assert_equal %w[media async], history
  end

  test 'truncates history' do
    12.times { |n| @state << "msg #{n + 1}" }

    assert_equal (2..12).map { |x| "msg #{x}" }.reverse, @state[0..10]
  end

  test 'read from history' do
    @state << 'async' << 'media'

    assert_equal 'async', @state[1]
  end

  test 'read from history with range' do
    @state << 'async' << 'media' << 'bot'

    assert_equal %w[media async], @state[1..2]
  end

  test 'set property' do
    @state[:foo, :bar] = 'baz'

    assert_equal 'baz', @redis.get('ambo:test:foo:bar')
  end

  test 'get property' do
    @state[:foo, :bar] = 'baz'

    assert_equal 'baz', @state[:foo, :bar]
  end
end
