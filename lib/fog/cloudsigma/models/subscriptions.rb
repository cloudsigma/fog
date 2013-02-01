require 'fog/core/collection'
require 'fog/cloudsigma/models/subscription'

module Fog
  module Compute
    class CloudSigma
      class Subscriptions < Fog::Collection
        model Fog::Compute::CloudSigma::Subscription

        def all
          resp = service.list_subscriptions
          data = resp.body['objects']
          load(data)
        end

        def get(vlan)
          resp = service.get_subscription(vlan)
          data = resp.body
          new(data)
        end

      end
    end
  end
end
