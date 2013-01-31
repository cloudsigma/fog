require 'fog/core/collection'
require 'fog/cloudsigma/models/libvolume'

module Fog
  module Compute
    class CloudSigma
      class Libvolumes < Fog::Collection
        model Fog::Compute::CloudSigma::LibVolume

        def all
          resp = service.list_libvolumes
          data = resp.body['objects']
          load(data)
        end

        def get(vol_id)
          resp = service.get_libvolume(vol_id)
          data = resp.body
          new(data)
        end

      end
    end
  end
end
