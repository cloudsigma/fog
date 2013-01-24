require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class IPConf < Fog::Model
        attribute :ip
        attribute :conf, :type => :string
      end
    end
  end
end
