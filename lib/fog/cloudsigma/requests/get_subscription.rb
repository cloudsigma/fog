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
          mock_get(:subscriptions, 200, sub_id)
        end
      end

    end
  end
end
