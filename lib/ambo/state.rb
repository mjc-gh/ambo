module Ambo
  class State
    def self.create_redis_connection
      Redis.new(url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/10' })
    end

    def initialize
      @redis = self.class.create_redis_connection
    end
  end
end
