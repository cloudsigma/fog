module Fog
  module Compute
    class CloudSigma
      class Real
        def get_ip(ip)
          request(:path => "ips/#{ip}/", :method => 'GET', :expects => 200)
        end
      end

      class Mock
        def get_ip(ip)
          mock_get(:ips, 200, ip)
        end
      end

    end
  end
end
