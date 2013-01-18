module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_volume(vol_id)
          request(:path => "drives/#{vol_id}/", :method => 'DELETE', :expects => [200, 202, 204])
        end
      end

      class Mock

      end

    end
  end
end
