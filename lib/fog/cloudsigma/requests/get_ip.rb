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
          data = self.data[:ips][ip]

          response = Excon::Response.new
          response.status = 200
          response.body = data

          response

        end
      end

    end
  end
end
