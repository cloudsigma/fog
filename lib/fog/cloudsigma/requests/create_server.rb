module Fog
  module Compute
    class CloudSigma
      class Real
        def create_server(data)
          request(:path => "servers/", :method => 'POST', :expects => [200, 202], :body => data)
        end
      end

      class Mock
        def create_server(data)
          uuid = self.class.random_uuid

          defaults = {'uuid' => uuid,
                      'status' => 'stopped',
                      'smp' => 1,
                      'hv_relaxed' => false,
                      'hv_tsc' => false,
                      'enable_numa' => false,
                      'cpus_instead_of_cores' => false,
                      'drives' => [],
                      'nics' => [],
                      'tags' => []
          }


          mock_create(:servers, 202, data, uuid, defaults) do |unclean_data|
            # TODO: Remove when API is fixed
            # Fix API wierdness for returning strings instead of numbers, so that the same tests are applicable for
            # both mocks and real infrastructure
            Hash[unclean_data.map { |k, v| [k, v.kind_of?(Numeric) ? v.to_s : v] }]
          end
        end
      end

    end
  end
end
