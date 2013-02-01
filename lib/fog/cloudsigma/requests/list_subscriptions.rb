module Fog
  module Compute
    class CloudSigma
      class Real
        def list_subscriptions
          request(:path => 'subscriptions/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_subscriptions
          data_array = self.data[:subscriptions].values

          response = Excon::Response.new
          response.status = 200
          response.body = {'objects' => data_array}

          response
        end
      end

    end
  end
end
