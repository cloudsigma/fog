module Fog
  module Compute
    class CloudSigma
      class Real
        def list_volumes
          request(:path => 'drives/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def list_volumes
          mock_list(:volumes, 200)
        end
      end

    end
  end
end
