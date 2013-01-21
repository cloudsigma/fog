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
          data_array = self.data[:servers].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
