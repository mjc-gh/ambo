# frozen_string_literal: true

module Ambo
  # Class for managing each bot's state
  class State
    include Comparable

    attr_reader :history

    def initialize
      @history = []
      @history_size = 1
    end

    def update(ctx)
      @history_size = ctx.config.every&.fetch(:repeat_after, 1) || 1

      self
    end

    def <<(msg_txt)
      @history.unshift time: Time.now, message: msg_txt
      @history.pop while @history.size > @history_size

      self
    end

    def last_sent
      @history.first&.fetch(:time)
    end

    def <=>(other)
      @history <=> other.history
    end
  end
end
