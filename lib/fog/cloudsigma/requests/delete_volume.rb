module Fog
  module Compute
    class CloudSigma
      class Real
        def delete_volume(vol_id)
          request(:path => "drives/#{vol_id}/", :method => 'DELETE', :expects => [200, 202, 204])
        end
      end

      class Mock
        def delete_volume(vol_id)
          mock_delete(:volumes, 204, vol_id)
        end
      end

    end
  end
end
