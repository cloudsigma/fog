module Fog
  module Compute
    class OpenStack
      class Real

        def create_volume(name, description, size, options={})
          data = {
            'volume' => {
              'display_name'        => name,
              'display_description' => description,
              'size'                => size
            }
          }

          vanilla_options = ['snapshot_id']
          vanilla_options.select{|o| options[o]}.each do |key|
            data['volume'][key] = options[key]
          end
          request(
            :body     => MultiJson.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => "os-volumes"
          )
        end

      end

      class Mock

        def create_volume(name, description, size, options={})
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'                  => Fog::Mock.random_numbers(2),
            'name'                => name,
            'description'         => description,
            'size'                => size,
            'status'              => 'creating',
            'snapshot_id'         => '4',
            'volume_type'         => nil,
            'availability_zone'   => 'nova',
            'created_at'          => Time.now,
            'attachments'         => []
          }
          self.data[:volumes][data['id']] = data
          response.body = { 'volume' => data }
          response
        end

      end

    end
  end
end
