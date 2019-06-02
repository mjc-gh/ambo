# frozen_string_literal: true

require 'test_helper'

class AmboTest < Minitest::Test
  test 'defines a version number' do
    refute_nil ::Ambo::VERSION
  end
end
