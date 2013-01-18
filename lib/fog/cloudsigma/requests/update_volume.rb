module Fog
  module Compute
    class CloudSigma
      class Real
        def update_volume(vol_id, data)
          request(:path => "drives/#{vol_id}/", :method => 'PUT', :expects => [200, 202], :body=>data)
        end
      end

      class Mock

      end

    end
  end
end
