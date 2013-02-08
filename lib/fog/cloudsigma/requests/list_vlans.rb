module Fog
  module Compute
    class CloudSigma
      class Real
        def list_vlans
          request(:path => 'vlans/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_vlans
          mock_list(:vlans, 200)
        end
      end

    end
  end
end
