# frozen_string_literal: true

require 'test_helper'

class AmboDeliveriesTwitter < Minitest::Test
  def config
    { consumer_key: 'a',
      consumer_secret: 'b',
      access_token: 'c',
      access_token_secret: 'd' }
  end

  test 'Ambo::Deliveries::Twitter::installed? when installed' do
    assert Ambo::Deliveries::Twitter.installed?
  end

  test 'initialize configures twitter client' do
    client = Ambo::Deliveries::Twitter
      .new(config)
      .instance_variable_get(:@client)

    assert_equal 'a', client.consumer_key
    assert_equal 'b', client.consumer_secret
    assert_equal 'c', client.access_token
    assert_equal 'd', client.access_token_secret
  end

  test 'send calls client update' do
    mock = Minitest::Mock.new
    mock.expect :update, nil, %w[foo]

    dt = Ambo::Deliveries::Twitter.new(config)
    dt.instance_variable_set(:@client, mock)
    dt.send 'foo'

    mock.verify
  end

  test 'NullClient defines update method' do
    clt = Ambo::Deliveries::Twitter::NullClient.new

    assert_respond_to clt, :update
  end
end
