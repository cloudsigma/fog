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
          self.data[:volumes].delete(vol_id)

          response = Excon::Response.new
          response.status = 204

          response
        end
      end

    end
  end
end
