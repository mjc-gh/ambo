require 'active_support'
require 'active_support/core_ext'
require 'concurrent'
require 'logger'

require 'ambo/version'

require 'ambo/concerns/loggable'
require 'ambo/loader'
require 'ambo/runner'

require 'ambo/contexts/twitter'
#require 'ambo/context/slack'
require 'ambo/contexts/periodic'
require 'ambo/context'

require 'ambo/tasks/periodic'
require 'ambo/task'

require 'ambo/deliveries/twitter'
#require 'ambo/deliveries/slack'

module Ambo
  Error = Class.new(StandardError)
  LoaderError = Class.new(Error)

  extend Loggable

  def self.logger
    @logger ||= Logger.new($stdout).tap do |l|
      l.level = Logger.const_get(ENV.fetch('AMBO_LOG_LEVEL') { 'DEBUG' }.upcase.to_sym)
      l.formatter = proc do |severity, datetime, progname, msg|
        progname ||= 'Unknown'
        time_str = datetime.utc.strftime('%d/%b/%Y:%H:%M:%S %z')

        "[#{severity}] [#{progname}] [#{time_str}] #{msg}\n"
      end
    end
  end

  def self.load(path)
    Loader.new(path).load!
  end

  def self.safely_require(gem_name)
    begin
      require gem_name
    rescue LoaderError => _
      debug_log "The gem #{gem_name} is not available"
    end
  end

  BEEP_BOOPS = %w(beep boop).freeze

  def self.random_beep_boops # :nodoc:
    BEEP_BOOPS.sample.capitalize.tap do |str|
      str << " #{BEEP_BOOPS.sample}" while str.size < 30 && rand > 0.25
    end
  end
end

# Safely load our runtime dependencies
Ambo.safely_require 'twitter'
