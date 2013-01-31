module Fog
  module Compute
    class CloudSigma
      class Real
        def list_libvolumes
          request(:path => 'libdrives/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_libvolumes
          data_array = self.data[:libvolumes].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
