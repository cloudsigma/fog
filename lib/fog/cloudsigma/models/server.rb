require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class Server < Fog::Model
        identity :id, :aliases => 'uuid'

        attribute :status, :type => 'string'
        attribute :vnc_password, :type => 'string'
        attribute :name, :type => 'string'
        attribute :cpus_instead_of_cores, :type => 'boolean'
        attribute :tags
        attribute :mem, :type => 'integer'
        attribute :nics
        attribute :enable_numa, :type => 'boolean'
        attribute :drives
        attribute :smp
        attribute :hv_relaxed, :type => 'boolean'
        attribute :hv_tsc, :type => 'boolean'
        attribute :meta
        attribute :owner
        attribute :runtime
        attribute :cpu, :type => 'integer'
        attribute :resource_uri, :type => 'string'



        def save
          if persisted?
            update
          else
            create
          end
        end

        def create
          requires :name, :cpu, :mem, :vnc_password
          data = {
              'name' => name,
              'cpu' => cpu,
              'mem' => mem,
              'vnc_password' => vnc_password,

              'drives' => drives || [],
              'nics' => nics || [],
              'smp' => smp || 1,
              'meta' => meta || {},
              'tags' => tags || [],

              'cpus_instead_of_cores' => cpus_instead_of_cores || false,
              'enable_numa' => enable_numa || false,
              'hv_relaxed' => hv_relaxed || false,
              'hv_tsc' => hv_tsc || false
          }

          response = service.create_server(data)
          new_attributes = response.body['objects'].first
          merge_attributes(new_attributes)
        end

        def update
          requires :identity, :name, :cpu, :mem, :vnc_password

          data = {
              'name' => name,
              'cpu' => cpu,
              'mem' => mem,
              'vnc_password' => vnc_password,

              'drives' => drives || [],
              'nics' => nics || [],
              'smp' => smp || 1,
              'meta' => meta || {},
              'tags' => tags || [],

              'cpus_instead_of_cores' => cpus_instead_of_cores || false,
              'enable_numa' => enable_numa || false,
              'hv_relaxed' => hv_relaxed || false,
              'hv_tsc' => hv_tsc || false
          }

          response = service.update_server(identity, data)
          new_attributes = response.body
          merge_attributes(new_attributes)

        end

        def destroy
          requires :identity

          service.delete_server(identity)
          true
        end

        alias :delete :destroy

        def reload
          requires :identity
          collection.get(identity)
        end

        def start(start_params={})
          requires :identity
          service.start_server(identity, start_params)
        end

        def stop
          requires :identity
          service.stop_server(identity)
        end

        def clone(clone_params={})
          requires :identity
          response = service.clone_server(identity, clone_params)

          self.class.new(response.body)
        end

      end
    end
  end
end