module Fog
  module Compute
    class CloudSigma
      class Real
        def list_volumes
          request(:path => 'drives/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_volumes
          data_array = self.data[:volumes].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
