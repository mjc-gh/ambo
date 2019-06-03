# frozen_string_literal: true

require 'test_helper'

class AmboTest < Minitest::Test
  test 'defines a version number' do
    refute_nil ::Ambo::VERSION
  end

  test 'Ambo::logger returns Logger instance' do
    assert_instance_of Logger, Ambo.logger
  end

  test 'Ambo::safely_require handles missing gems' do
    assert Ambo.safely_require('foobar')
  end
end
