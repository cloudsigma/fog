module Fog
  module Compute
    class CloudSigma
      class Real
        def get_current_usage
          request(:path => "currentusage/", :method => 'GET', :expects => [200])
        end
      end

      class Mock
        def get_current_usage

        end
      end

    end
  end
end
