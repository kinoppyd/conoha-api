module ConohaApi
  module Configurable

    attr_reader :api_endpoint
    attr_reader :tenant_id
    attr_reader :login
    attr_reader :password
    attr_reader :connection_options
    attr_reader :middleware
    attr_reader :proxy
    attr_reader :raise_error

    class << self
      def keys
        @keys || [
          :api_endpoint,
          :tenant_id,
          :login,
          :password,
          :connection_options,
          :middleware,
          :proxy,
          :raise_error,
        ]
      end
    end

    def configure
      yield
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

  end
end
