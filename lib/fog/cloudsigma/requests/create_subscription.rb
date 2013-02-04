module Fog
  module Compute
    class CloudSigma
      class Real
        def create_subscription(data)
          request(:path => "subscriptions/", :method => 'POST', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def create_subscription(data)

        end
      end

    end
  end
end
