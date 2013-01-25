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
          data_array = self.data[:vlans].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
