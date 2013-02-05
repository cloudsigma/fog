module Fog
  module Compute
    class CloudSigma
      class Real
        def update_profile(data)
          request(:path => "profile/", :method => 'PUT', :expects => [200], :body=>data)
        end
      end

      class Mock
        def update_profile(data)
        end
      end

    end
  end
end
