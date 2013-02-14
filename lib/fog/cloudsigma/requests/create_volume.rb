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

          defaults = {'uuid' => uuid,
                      'status' => 'unmounted',
                      'tags' => [],
                      'mounted_on' => [],
                      'affinities' => [],
                      'licenses' => [],
                      'jobs' => [],
                      'allow_multimount' => false,
          }

          mock_create(:volumes, 202, data, uuid, defaults)
        end
      end

    end
  end
end
