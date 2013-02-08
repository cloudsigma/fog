module Fog
  module Compute
    class CloudSigma
      class Real
        def list_ips
          request(:path => 'ips/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_ips
          mock_list(:ips, 200)
        end
      end

    end
  end
end
