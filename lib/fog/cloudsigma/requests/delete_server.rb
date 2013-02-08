module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_server(server_id)
          request(:path => "servers/#{server_id}/", :method => 'DELETE', :expects => [200, 202, 204])
        end
      end

      class Mock
        def delete_server(server_id)
          mock_delete(:servers, 204, server_id)
        end
      end

    end
  end
end
