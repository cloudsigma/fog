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

      request :create_volume
      request :get_volume
      request :list_volumes
      request :update_volume
      request :delete_volume
      request :clone_volume

      model :ipconf
      model :nic
      model :mountpoint
      model :server
      collection :servers

      request :create_server
      request :get_server
      request :list_servers
      request :update_server
      request :delete_server
      request :start_server
      request :stop_server
      request :open_vnc
      request :close_vnc
      request :clone_server

      model :ip
      collection :ips

      request :list_ips
      request :get_ip

      model :vlan
      collection :vlans

      request :list_vlans
      request :get_vlan


      class Mock
        include Collections

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
                :volumes => {},
                :servers => {},
            }
          end
        end

        def self.random_uuid
          # Insert '4' at 13th position and 'a' at 17th as per uuid4 spec
          hex = Fog::Mock.random_hex(30).insert(12,'4').insert(16, 'a')
          # Add dashes
          "#{hex[0...8]}-#{hex[8...12]}-#{hex[12...16]}-#{hex[16...20]}-#{hex[20..32]}"
        end

        def data
          self.class.data[:test]
        end

        def initialize(options={})
          @init_options = options

          #setup_connection(options)
        end

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
