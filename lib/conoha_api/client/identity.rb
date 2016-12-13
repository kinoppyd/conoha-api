module ConohaApi
  class Client
    module Identity
      SERVICE = "identity"

      def identity_version
        get "", no_auth: true
      end

      def tokens
        request_json = {
          auth: {
            passwordCredentials: {
              username: @login,
              password: @password
            },
            tenantId: @tenant_id
          }
        }

        post "/v2.0/tokens", request_json, no_auth: true
      end
    end
  end
end
