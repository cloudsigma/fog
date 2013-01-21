module Fog
  module Compute
    class CloudSigma
      class Real
        def create_volume(data)
          request(:path => "drives/", :method => 'POST', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def create_volume(data)
          uuid = self.class.random_uuid
          data['uuid'] = uuid
          data['status'] = 'creating'
          response = Excon::Response.new
          response.body = {'objects' => [data]}
          response.status = 202

          ready_volume = data.dup # new copy so that it is active on call to list
          ready_volume['status'] = 'active'
          self.data[:volumes][uuid] = ready_volume

          response
        end
      end

    end
  end
end
