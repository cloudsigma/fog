module Fog
  module Compute
    class CloudSigma
      class Real
        def list_volumes
          request(:path => 'drives/detail/', :method => 'GET', :expects => [200])
        end
      end

      class Mock

      end

    end
  end
end
