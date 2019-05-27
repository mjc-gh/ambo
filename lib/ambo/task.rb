module Ambo
  module Task
    def self.create_pool(size = nil)
      size ||= Concurrent::Utility::ProcessorCounter.new.processor_count

      Concurrent::FixedThreadPool.new(size)
    end
  end
end
