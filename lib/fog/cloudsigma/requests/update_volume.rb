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
          volume = self.data[:volumes][vol_id]
          volume.merge!(data)

          response = Excon::Response.new
          response.status = 200
          response.body = volume

          response
        end
      end

    end
  end
end