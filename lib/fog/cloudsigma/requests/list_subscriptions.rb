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
          mock_list(:subscriptions, 200)
        end
      end

    end
  end
end
