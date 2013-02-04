require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class MountPoint < Fog::Model
        attribute :device, :type => 'string'
        attribute :dev_channel, :type => 'string'
        attribute :volume, :aliases => 'drive'
        attribute :boot_order, :type => 'integer'

      end
    end
  end
end
