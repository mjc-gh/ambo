module Ambo
  class Context
    include ActiveSupport::Configurable

    include Context::Twitter
    #include Context::Slack

    include Context::Periodic
    #include Context::Reply
  end
end
