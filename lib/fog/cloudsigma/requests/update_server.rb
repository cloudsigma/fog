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
          mock_update(data, :servers, 200,  server_id)
        end
      end

    end
  end
end
