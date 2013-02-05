module Fog
  module Compute
    class CloudSigma
      class Real
        def get_profile
          request(:path => "profile/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_profile

        end
      end

    end
  end
end
