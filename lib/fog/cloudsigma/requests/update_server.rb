module Fog
  module Compute
    class CloudSigma
      class Real
        def update_server(server_id, data)
          request(:path => "servers/#{server_id}/", :method => 'PUT', :expects => [200, 202], :body=>data)
        end
      end

      class Mock
        def update_server(server_id, data)
          # TODO: Remove when API is fixed
          # Fix API wierdness for returning strings instead of numbers, so that the same tests are applicable for
          # both mocks and real infra
          cleaned_data = Hash[data.map {|k,v| [k, v.kind_of?(Numeric) ? v.to_s : v]}]
          mock_update(cleaned_data, :servers, 200,  server_id)
        end
      end

    end
  end
end
