require 'time'
require 'conoha_api/connection'

module ConohaApi
  module Authentication
    attr_reader :token_expire_time

    def ready_for_authentication?
      !! (@login && @password)
    end

    def token_expired?
      return true unless token_expire_time
      token_expire_time < Time.now
    end

    def token_expires(expire_time)
      @token_expire_time = case expire_time
      when String
        Time.iso8601(expire_time)
      when Date
        expire_time
      else
        raise
      end
    end
  end
end
