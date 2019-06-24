# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ambo/version'

Gem::Specification.new do |spec|
  spec.name          = 'ambo'
  spec.version       = Ambo::VERSION
  spec.authors       = ['Michael J Coyne']
  spec.email         = ['mikeycgto+ambo@gmail.com']

  spec.summary       = 'Async Media Bot (AMBo)'
  spec.description   = 'An Async Media bot for Twitter and Slack'
  spec.homepage      = 'https://github/mjc-gh/ambo'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 5.2'
  spec.add_dependency 'concurrent-ruby', '~> 1.1'
  spec.add_dependency 'connection_pool', '~> 2.2'
  spec.add_dependency 'redis', '~> 4.1'
  spec.add_dependency 'tod', '~> 2.2'

  spec.add_runtime_dependency 'twitter', '~> 6.2'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'timecop'
end
