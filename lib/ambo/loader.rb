# frozen_string_literal: true

module Ambo
  # Parses and loads into bot via the {Context} class. This class then calls
  # {Ambo::Loaded#wait_until_exit!} and blocks until the program is shutdown
  class Loader
    include Loggable

    def initialize(path)
      @path = path
      @runner = Runner.new
    end

    def load!
      info_log "Started with pid #{Process.pid}"

      each_file do |file|
        eval_context file

        debug_log "Loaded #{file}"
      end

      info_log 'Starting bot runner'

      @runner.wait_until_exit!

      info_log 'Goodbye!'
    end

    private

    def eval_context(file)
      bot_name = File.basename(file, File.extname(file))
      bot_name = File.basename(bot_name, '.ambo')

      @runner << Context.new(bot_name).tap do |ctx|
        ctx.instance_eval File.read(file), file
        ctx.config.compile_methods!
      end
    end

    def each_file
      Dir["#{@path}/**/*.ambo.rb", "#{@path}/**/*.ambo"].each do |file|
        yield file
      end
    end
  end
end
