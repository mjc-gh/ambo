# frozen_string_literal: true

require 'test_helper'

class AmboStateTest < Minitest::Test
  test '#last_sent with no history' do
    state = Ambo::State.new

    assert_nil state.last_sent
  end

  test '#last_sent with history' do
    Timecop.freeze do
      state = Ambo::State.new
      state << 'msg'

      assert_equal Time.now, state.last_sent
    end
  end

  test '#<< adds to history' do
    Timecop.freeze do
      state = Ambo::State.new
      state << 'msg'

      assert_equal [
        time: Time.now, message: 'msg'
      ], state.history
    end
  end

  test '#<< truncates history' do
    Timecop.freeze do
      state = Ambo::State.new
      state << 'msg' << 'other'

      assert_equal [
        time: Time.now, message: 'other'
      ], state.history
    end
  end

  test '#<< truncates history with updated ctx configuration' do
    Timecop.freeze do
      ctx = Ambo::Context.new('foo_bot')
      ctx.every 2.seconds, repeat_after: 2

      state = Ambo::State.new
      state.update(ctx)
      state << 'one' << 'two' << 'three' << 'four'

      assert_equal [
        { time: Time.now, message: 'four' },
        { time: Time.now, message: 'three' }
      ], state.history
    end
  end

  test '#<=> with unequal states' do
    state1 = Ambo::State.new
    state1 << 'foo'

    state2 = Ambo::State.new
    state2 << 'foo'

    refute_equal state1, state2
  end

  test '#<=> with unequal states' do
    Timecop.freeze do
      state1 = Ambo::State.new
      state1 << 'foo'

      state2 = Ambo::State.new
      state2 << 'foo'

      assert_equal state1, state2
    end
  end
end
