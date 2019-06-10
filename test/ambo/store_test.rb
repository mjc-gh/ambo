# frozen_string_literal: true

require 'test_helper'

class AmboStoreTest < Minitest::Test
  setup do
    @ctx = Ambo::Context.new('foo_bot')
    @ctx.every 4, repeat_after: 10
  end

  teardown { clear_stores! }

  test '#load_or_create with no existing state returns new clean state' do
    store = Ambo::Store.new

    assert_empty store.load_or_create(@ctx).history
  end

  test '#load_or_create with existing state' do
    state = Ambo::State.new
    state.update(@ctx)
    state << 'foo' << 'bar'

    store = Ambo::Store.new
    store.save(@ctx, state)

    assert_equal state, store.load_or_create(@ctx)
  end
end
