require 'fog/cloudsigma/error'

module Fog
  module CloudSigma
    module CloudSigmaConnection

      def auth_header(type = :basic)
        case type
          when :basic
            unless @username and @password
              raise ArgumentError, 'Username and password required for basic auth'
            end
            {'Authorization' => 'Basic ' << Base64.encode64("#{@username}:#{@password}").gsub("\n", '')}
          else
            unless @username and @password
              raise ArgumentError, 'Username and password required for basic auth'
            end
            {'Authorization' => 'Basic ' << Base64.encode64("#{@username}:#{@password}").gsub("\n", '')}
        end
      end

      def setup_connection(options)
        @persistent = options[:persistent] || false
        @connection_options = options[:connection_options] || {}
        @connection_options[:ssl_verify_peer] = false

        @auth_type = options[:cloudsigma_auth_type] || :basic

        @username = options[:cloudsigma_username]
        @password = options[:cloudsigma_password]

        @scheme = options[:cloudsigma_scheme] || 'https'
        @host = options[:cloudsigma_host] || 'turloapi.lvs.cloudsigma.com'
        @port = options[:cloudsigma_port] || '443'
        @api_path_prefix = options[:cloudsigma_api_path_prefix] || ''
        @api_version = options[:cloudsigma_api_version] || '2.0'
        @path_prefix = "#{@api_path_prefix}/#{@api_version}/"

        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
      end

      def request(params)
        params[:headers] = params.fetch(:headers, {}).merge(auth_header(@auth_type))
        #TODO: Remove Host header when API server is fixed to acceps port in Host header
        params[:headers].merge!({
                                    'Host' => 'turloapi.lvs.cloudsigma.com',
                                    'Content-Type' => 'application/json; charset=utf-8'
                                })

        req_path = params[:path]
        params[:path] = "#{@path_prefix}#{req_path}"


        params[:body] = Fog::JSON.encode(params[:body]) if params[:body]

        begin
          response = @connection.request(params)
        rescue Excon::Errors::HTTPStatusError => e

          e.response.body = Fog::JSON.decode(e.response.body) unless e.response.body.empty?
          err = Fog::CloudSigma::Errors.slurp_http_status_error(e)

          raise err
        end
        response.body = Fog::JSON.decode(response.body) unless response.body.empty?

        response
      end

      def list_request(path, override_params={})
        default_params = {:method => 'GET', :expects => 200, :query => {:limit => 0}}
        override_params[:path] = path
        params = default_params.merge(override_params)

        request(params)
      end

      def get_request(path, override_params={})
        default_params = {:method => 'GET', :expects => 200}
        override_params[:path] = path
        params = default_params.merge(override_params)

        request(params)
      end

      def delete_request(path, override_params={})
        default_params = {:method => 'DELETE', :expects => 204}
        override_params[:path] = path
        params = default_params.merge(override_params)

        request(params)
      end

      def create_request(path, data, override_params={})
        default_params = {:method => 'POST', :expects => [200, 202]}

        override_params[:path] = path
        override_params[:body] = data
        params = default_params.merge(override_params)

        request(params)
      end

      def update_request(path, data, override_params={})
        default_params = {:method => 'PUT', :expects => [200, 202]}

        override_params[:path] = path
        override_params[:body] = data
        params = default_params.merge(override_params)

        request(params)
      end
    end
  end
end