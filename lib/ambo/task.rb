# frozen_string_literal: true

module Ambo
  # Small utility module for asynchronous task management
  module Task
    def self.create_pool(size = nil)
      size ||= Concurrent::Utility::ProcessorCounter.new.processor_count

      Concurrent::FixedThreadPool.new(size)
    end
  end
end
