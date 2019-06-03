# frozen_string_literal: true

module Ambo
  # DSL context class; every loaded bot source file is
  # {BasicObject#instance_eval} against new instances of this class.
  class Context
    include ActiveSupport::Configurable

    include Contexts::Twitter
    # include Context::Slack

    include Contexts::Periodic
    # include Context::Reply

    attr_reader :bot_name

    def initialize(bot_name)
      @bot_name = bot_name
    end
  end
end
