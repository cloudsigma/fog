module Fog
  module Compute
    class CloudSigma
      class Real
        def get_volume(vol_id)
          request(:path => "drives/#{vol_id}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock

      end

    end
  end
end
