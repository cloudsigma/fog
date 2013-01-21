module Fog
  module Compute
    class CloudSigma
      class Real
        def get_server(server_id)
          request(:path => "servers/#{server_id}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_server(server_id)
          data = self.data[:servers][server_id]

          response = Excon::Response.new
          response.status = 200
          response.body = data

          response

        end
      end

    end
  end
end
