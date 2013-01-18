module Fog
  module Compute
    class CloudSigma
      class Real
        def create_volume(data)
          request(:path => "drives/", :method => 'POST', :expects => [200, 202], :body=>data)
        end
      end

      class Mock

      end

    end
  end
end
