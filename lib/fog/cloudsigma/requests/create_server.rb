module Fog
  module Compute
    class CloudSigma
      class Real
        def create_server(data)
          request(:path => "servers/", :method => 'POST', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def create_server(data)
          uuid = self.class.random_uuid
          data['uuid'] = uuid
          data['status'] = 'stopped'
          response = Excon::Response.new
          response.body = {'objects' => [data]}
          response.status = 202

          self.data[:servers][uuid] = data

          response
        end
      end

    end
  end
end
