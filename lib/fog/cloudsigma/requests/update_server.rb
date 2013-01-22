module Fog
  module Compute
    class CloudSigma
      class Real
        def update_server(server_id, data)
          request(:path => "servers/#{server_id}/", :method => 'PUT', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def update_server(server_id, data)
          server = self.data[:servers][server_id]
          server.merge!(data)

          response = Excon::Response.new
          response.status = 200
          response.body = server

          response
        end
      end

    end
  end
end
