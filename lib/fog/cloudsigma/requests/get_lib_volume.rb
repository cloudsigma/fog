module Fog
  module Compute
    class CloudSigma
      class Real
        def get_lib_volume(vol_id)
          request(:path => "libdrives/#{vol_id}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_lib_volume(vol_id)
          data = self.data[:libvolumes][vol_id]

          response = Excon::Response.new
          response.status = 200
          response.body = data

          response

        end
      end

    end
  end
end
