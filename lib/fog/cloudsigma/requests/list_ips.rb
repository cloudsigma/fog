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
          data_array = self.data[:ips].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
