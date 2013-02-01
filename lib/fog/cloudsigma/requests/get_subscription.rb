module Fog
  module Compute
    class CloudSigma
      class Real
        def get_subscription(sub_id)
          request(:path => "subscriptions/#{sub_id}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_subscription(sub_id)
          data = self.data[:subscriptions][sub_id]

          response = Excon::Response.new
          response.status = 200
          response.body = data

          response

        end
      end

    end
  end
end
