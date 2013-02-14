module Fog
  module Compute
    class CloudSigma
      class Real
        def update_server(server_id, data)
          update_request("servers/#{server_id}/", data)
        end
      end

      class Mock
        def update_server(server_id, data)
          mock_update(data, :servers, 200,  server_id)
        end
      end

    end
  end
end
