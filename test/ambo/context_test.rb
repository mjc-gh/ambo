# frozen_string_literal: true

require 'test_helper'

class AmboContextsTest < Minitest::Test
  test '#bot_name' do
    ctx = Ambo::Context.new('foo_bot')

    assert_equal 'foo_bot', ctx.bot_name
  end
end
