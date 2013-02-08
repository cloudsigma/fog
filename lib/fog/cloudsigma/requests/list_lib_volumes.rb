module Fog
  module Compute
    class CloudSigma
      class Real
        def list_lib_volumes
          request(:path => 'libdrives/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_lib_volumes
          mock_list(:libvolumes, 200)
        end
      end

    end
  end
end
