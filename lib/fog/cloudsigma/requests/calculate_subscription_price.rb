module Fog
  module Compute
    class CloudSigma
      class Real
        def calculate_subscription_price(data)
          request(:path => "subscriptioncalculator/", :method => 'POST', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def calculate_subscription_price(data)

        end
      end

    end
  end
end
