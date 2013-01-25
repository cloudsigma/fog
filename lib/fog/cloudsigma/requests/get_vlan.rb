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
          data = self.data[:vlans][vlan]

          response = Excon::Response.new
          response.status = 200
          response.body = data

          response

        end
      end

    end
  end
end
