require 'fog/compute'
require 'fog/cloudsigma'

module Fog
  module Compute
    class CloudSigma < Fog::Service

      #requires :necessary_credential
      recognizes :cloudsigma_password, :cloudsigma_user_name

      model_path 'fog/cloudsigma/models'
      request_path 'fog/cloudsigma/requests'

      model :volume
      collection :volumes

      request :list_volumes
      request :get_volume
      request :create_volume
      request :update_volume
      request :delete_volume

      #model :server
      #collection :servers

      class Mock
        include Collections

      end

      class Real
        include Collections
        include Fog::CloudSigma::CloudSigmaConnection

        def initialize(options={})
          @init_options = options

          setup_connection(options)
        end

      end

    end
  end

end
