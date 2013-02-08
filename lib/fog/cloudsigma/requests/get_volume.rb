module Fog
  module Compute
    class CloudSigma
      class Real
        def get_volume(vol_id)
          request(:path => "drives/#{vol_id}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_volume(vol_id)
          mock_get(:volumes, 200, vol_id)
        end
      end

    end
  end
end
