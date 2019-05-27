# AMBo

**A**synchronous **M**edia **Bo**t

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ambo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ambo

## Usage

**TODO** This library is still very much a work in progress. Once the
design begins to solidify, complete usage docs as well as automated
tests will be added to this project. Standby!!

### Example

A basic Twitter bot

```ruby
# Tweet under the @RandomEmojiBot account
tweet_as 'RandomEmojiBot'

# Tweet every 4 to 8 hours
# Allow repeats after 20 messages
every 4.hours, 8.hours, repeat_after: 20

# This block is called to generate a new message
next_message do
 ["😀", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😈", "😉", "😊",
  "😋", "😌", "😍", "😎", "😏", "😛", "😜", "😝", "🙂", "🙃", "🙄"].sample
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the
`.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/mjc-gh/ambo. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ambo project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/mjc-gh/ambo/blob/master/CODE_OF_CONDUCT.md).
