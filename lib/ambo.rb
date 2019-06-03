# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'concurrent'
require 'logger'
require 'redis'

require 'ambo/version'

require 'ambo/concerns/loggable'
require 'ambo/loader'
require 'ambo/runner'
require 'ambo/state'
require 'ambo/store'

require 'ambo/contexts/twitter'
# require 'ambo/context/slack'
require 'ambo/contexts/periodic'
require 'ambo/context'

require 'ambo/tasks/periodic'
require 'ambo/task'

require 'ambo/deliveries/twitter'
# require 'ambo/deliveries/slack'

# Main module for the AMBo framework
module Ambo
  Error = Class.new(StandardError)
  LoaderError = Class.new(Error)

  LOG_OUTPUT = defined?(Minitest) ? 'log/test.log' : $stdout

  def self.logger
    @logger ||= Logger.new(LOG_OUTPUT).tap do |l|
      level = ENV.fetch('AMBO_LOG_LEVEL') { 'DEBUG' }.upcase.to_sym

      l.level = Logger.const_get(level)
      l.formatter = proc do |severity, datetime, progname, msg|
        progname ||= 'Ambo'
        time_str = datetime.utc.strftime('%d/%b/%Y:%H:%M:%S %z')

        "[#{severity}] [#{progname}] [#{time_str}] #{msg}\n"
      end
    end
  end

  def self.load(path)
    Loader.new(path).load!
  end

  def self.safely_require(gem_name)
    require gem_name
  rescue LoadError => _e
    logger.debug "The gem #{gem_name} is not available"
  end

  BEEP_BOOPS = %w[beep boop].freeze

  def self.random_beep_boops # :nodoc:
    BEEP_BOOPS.sample.capitalize.tap do |str|
      str << " #{BEEP_BOOPS.sample}" while str.size < 30 && rand > 0.25
    end
  end
end

# Safely load our runtime dependencies
Ambo.safely_require 'twitter'
