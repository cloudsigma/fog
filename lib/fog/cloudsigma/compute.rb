require 'fog/compute'
require 'fog/cloudsigma/connection'


module Fog
  module Compute
    class CloudSigma < Fog::Service
      requires :cloudsigma_password, :cloudsigma_username
      recognizes :cloudsigma_password, :cloudsigma_username

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

      model :lib_volume
      collection :lib_volumes
      request :get_lib_volume
      request :list_lib_volumes

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

      model :subscription
      collection :subscriptions
      request :list_subscriptions
      request :get_subscription
      request :create_subscription
      request :extend_subscription

      model :price_calculation
      request :calculate_subscription_price

      model :profile
      request :get_profile
      request :update_profile

      model :balance
      request :get_balance

      model :current_usage
      request :get_current_usage

      model :pricing
      request :get_pricing


      module CommonMockAndReal
        def profile
          response = get_profile
          Profile.new(response.body)
        end

        def balance
          response = get_balance

          Balance.new(response.body)
        end

        def current_usage
          response = get_current_usage

          CurrentUsage.new(response.body['usage'])
        end

        def currency
          # Cache since currency does not change
          @currency ||= profile.currency

        end

        def pricing
          resp = get_princing(currency)

          resp.body['objects']
        end

        def current_pricing_levels
          resp = get_pricing(currency)

          resp.body['current']
        end

        def next_pricing_levels
          resp = get_pricing(currency)

          resp.body['next']
        end

        def subscription_pricing
          resp = get_pricing(currency, true)

          current_levels = resp.body['current']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.detect do |price|
              price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end

        def current_pricing
          resp = get_pricing(currency)

          current_levels = resp.body['current']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.detect do |price|
              price['level'] == level && price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end

        def next_pricing
          resp = get_pricing(currency)

          current_levels = resp.body['next']
          current_prices = resp.body['objects']

          current_pricing_pairs = current_levels.map do |resource, level|
            price_for_resource_and_level = current_prices.detect do |price|
              price['level'] == level && price['resource'] == resource
            end
            price_for_resource_and_level ||= {}

            [resource, price_for_resource_and_level]
          end

          Pricing.new(Hash[current_pricing_pairs])
        end

      end

      class Mock
        include Collections
        include CommonMockAndReal
        require 'fog/cloudsigma/mock_data'

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = mock_data
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

        def mock_get(obj_or_collection, status, key=nil)
          data = self.data[obj_or_collection]
          if key
            data = data[key]
            unless data
              raise Fog::CloudSigma::Errors::Error.new("Object with uuid #{key} does not exist", 'notexist')
            end
          end

          Excon::Response.new(:body => Fog::JSON.decode(Fog::JSON.encode(data)), :status => status)
        end

        def mock_list(collection, status)
          data_array = self.data[collection].values

          Excon::Response.new(:body => {'objects' => data_array}, :status => status)
        end

        def mock_update(data, obj_or_collection, status, key)
          if key
            unless self.data[obj_or_collection][key]
              raise Fog::CloudSigma::Errors::Error.new("Object with uuid #{key} does not exist", 'notexist')
            end
            new_data = self.data[obj_or_collection][key].merge(data)
            reencoded_data = Fog::JSON.decode(Fog::JSON.encode(new_data))
            self.data[obj_or_collection][key] = reencoded_data
          else
            new_data = self.data[obj_or_collection].merge(data)
            reencoded_data = Fog::JSON.decode(Fog::JSON.encode(new_data))
            self.data[obj_or_collection] = reencoded_data
          end

          Excon::Response.new(:body =>  Fog::JSON.decode(Fog::JSON.encode(new_data)), :status => status)
        end

        def mock_delete(collection, status, key)
          self.data[collection].delete(key)

          Excon::Response.new(:body => '', :status => status)
        end

        def mock_create(collection, status, data, key, defaults={}, &clean_before_store)
          data_with_defaults = data.merge(defaults) {|k, oldval, newval| oldval == nil ? newval: oldval}

          if clean_before_store
            cleaned_data = clean_before_store.call(data_with_defaults)
          else
            cleaned_data = data_with_defaults
          end

          # Encode and decode into JSON so that the result is the same as the one returned and parsed from the API
          final_data =  Fog::JSON.decode(Fog::JSON.encode(cleaned_data))

          self.data[collection][key] = final_data

          # dup so that stored data is different instance from response data
          response_data = final_data.dup

          response = Excon::Response.new
          response.body = {'objects' => [response_data]}
          response.status = status

          response
        end
      end

      class Real
        include Collections
        include CommonMockAndReal
        include Fog::CloudSigma::CloudSigmaConnection

        def initialize(options={})
          @init_options = options

          setup_connection(options)
        end


      end

    end
  end

end
