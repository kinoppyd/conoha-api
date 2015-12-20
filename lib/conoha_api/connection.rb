require "conoha_api/authentication"
require "conoha_api/configurable"

module ConohaApi
  module Connection
    attr_reader :current_connection
    
    include ConohaApi::Authentication
    include ConohaApi::Configurable

    def get(path, options = {})
      request(:get, path, nil, options)
    end

    def put(path, data, options = {})
      request(:put, path, data, options)
    end

    def delete(path, options = {})
      request(:delete, path, nil, options)
    end

    def post(path, data, options = {})
      request(:post, path, data, options)
    end

    private

    def agent
      endpoint = @connection_stack.last
      (@connections ||= {})[endpoint] ||= Sawyer::Agent.new(endpoint, sawyer_options) do |http|
        http.headers['content-type'] = 'application/json'
      end

    end

    def request(method, path, data, options = {})
      # find module original method defined and add endpoint to connection stack
      origin = search_caller(caller(0..2))
      endpoint = URI.parse(endpoints[origin::SERVICE] || @api_endpoint)
      (@connection_stack ||= []).push("#{endpoint.scheme}://#{endpoint.host}")

      unless options[:no_auth]
        options = options.dup
        (options[:headers] ||= {})["X-Auth-Token"] = credential.access.token.id
      end

      path = File.join(endpoint.path, path)
      res = agent.call(method, URI::Parser.new.escape(path), data, options)

      @connection_stack.pop
      res.data
    end

    def search_caller(call_stack)
      res = call_stack[2].match(/`(?<method>.*)'/)
      self.method(res[:method]).owner
    end

    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_ops = @connection_options
      conn_ops[:builder] = @middleware if @middleware
      conn_ops[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_ops)

      opts
    end
  end
end
