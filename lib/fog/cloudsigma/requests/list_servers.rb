module Fog
  module Compute
    class CloudSigma
      class Real
        def list_servers
          request(:path => 'servers/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_servers
          mock_list(:servers, 200)
        end
      end

    end
  end
end
