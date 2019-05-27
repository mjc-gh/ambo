module Ambo
  module Tasks
    class Periodic
      include Loggable

      def initialize(options, &block)
        @options = options
        @block = block

        schedule!
      end

      def cancel
        @current_task&.cancel
      end

      private

      def schedule!
        callback = @block

        @current_task = Concurrent::ScheduledTask.execute(delay) do
          begin
            callback.call
          rescue StandardError => error
            fatal_log "Task failed: #{error.message} (#{error.class})"
            fatal_log error.backtrace.join("\n")
          else
            debug_log 'Task successful'
          ensure
            schedule!
          end
        end
      end

      def delay
        if @options.key? :delay then @options[:delay].to_i
        else rand(@options[:min]..@options[:max]).to_i
        end
      end
    end
  end
end
