# frozen_string_literal: true

tweet_as 'Foo'

every 1.hour

next_message do
  'This is a test'
end
