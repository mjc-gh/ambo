# frozen_string_literal: true

module Ambo
  # Class for managing and persisting each bot's "memory"
  class State
    def initialize(ctx, redis, history_limit: 999)
      @ctx   = ctx
      @redis = redis

      @history_limit = history_limit
    end

    def <<(msg)
      history_key = redis_key_for(:history)

      @redis.with do |conn|
        conn.lpush history_key, msg
        conn.ltrim history_key, 0, @history_limit
      end

      self
    end

    def [](*key_parts)
      f_arg = key_parts.first

      case f_arg
      when Integer then read_history f_arg
      when Range then read_history_range f_arg
      else read_property key_parts
      end
    end

    def []=(*key_parts)
      unless key_parts.size >= 2
        raise ArgumentError, 'at least 2 arguments are needed'
      end

      value = key_parts.pop

      @redis.with { |conn| conn.set redis_key_for(key_parts), value }
    end

    private

    def read_property(key_parts)
      @redis.with { |conn| conn.get redis_key_for(key_parts) }
    end

    def read_history(index)
      @redis.with { |conn| conn.lindex redis_key_for(:history), index }
    end

    def read_history_range(range)
      @redis.with do |conn|
        conn.lrange redis_key_for(:history), range.first, range.last
      end
    end

    def redis_key_for(key_parts)
      "ambo:#{@ctx.bot_name}:#{Array(key_parts) * ':'}"
    end
  end
end
