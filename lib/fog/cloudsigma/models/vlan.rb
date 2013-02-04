require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class VLAN < Fog::CloudSigma::CloudsigmaModel
        identity :id, :aliases => 'uuid'
        attribute :tags
        attribute :servers
        attribute :meta
        attribute :owner
        attribute :resource_uri, :type => :string
        attribute :subscription

      end
    end
  end
end
