module Fog
  module Compute
    class CloudSigma
      class Real
        def get_vlan(vlan)
          request(:path => "vlans/#{vlan}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_vlan(vlan)
          mock_get(:vlans, 200, vlan)
        end
      end

    end
  end
end
