module Fog
  module Compute
    class CloudSigma
      class Real
        def create_subscription(data)
          create_request("subscriptions/", data)
        end
      end

      class Mock
        def create_subscription(data)

        end
      end

    end
  end
end
