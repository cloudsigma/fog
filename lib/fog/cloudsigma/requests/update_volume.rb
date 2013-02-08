module Fog
  module Compute
    class CloudSigma
      class Real
        def update_volume(vol_id, data)
          request(:path => "drives/#{vol_id}/", :method => 'PUT', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def update_volume(vol_id, data)
          mock_update(data, :volumes, 200,  vol_id)
        end
      end

    end
  end
end
