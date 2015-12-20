require "sawyer"

require "conoha_api/connection"
require "conoha_api/configurable"
require "conoha_api/authentication"

require "conoha_api/client/compute"
require "conoha_api/client/identity"

module ConohaApi
  class Client
    class_variable_set(:@@endpoints, {})

    include ConohaApi::Connection
    include ConohaApi::Configurable
    include ConohaApi::Authentication

    include ConohaApi::Client::Compute
    include ConohaApi::Client::Identity

    def initialize(options = {})
      Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || ConohaApi.instance_variable_get(:"@#{key}"))
      end
      credential
    end

    def endpoints
      @@endpoints
    end

    def credential
      @credential = nil if token_expired?
      @credential ||= auth
    end

    private

    def auth
      raise unless ready_for_authentication?
      auth_infomations = tokens
      token_expires(auth_infomations.access.token.expires)
      authed_endpoints(auth_infomations)
      auth_infomations
    end

    def authed_endpoints(auth_infomations)
      auth_infomations.access.serviceCatalog.each do |endpoint|
        @@endpoints[endpoint.type] = endpoint.endpoints.find { |e| e.region = 'tyo1' }.publicURL
      end
    end
  end
end
