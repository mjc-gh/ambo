# frozen_string_literal: true

module Ambo
  # This class persists serialized {Ambo::State} instance
  class Store
    REDIS_URL = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/10' }

    def initialize
      # TODO: use a connection pool?
      @redis = Redis.new(url: REDIS_URL)
    end

    # TODO: sign serialized state before writing it to redis
    def save(ctx, state)
      @redis.set self.class.redis_key_for(ctx), Marshal.dump(state)
    end

    # TODO: verify payload before Marshal.load
    # rubocop:disable Security/MarshalLoad
    def load_or_create(ctx)
      serialized = @redis.get(self.class.redis_key_for(ctx))

      (serialized.nil? ? State.new : Marshal.load(serialized)).tap do |state|
        state.update(ctx)
      end
    end
    # rubocop:enable Security/MarshalLoad

    def self.redis_key_for(ctx)
      "ambo:#{ctx.bot_name}"
    end
  end
end
