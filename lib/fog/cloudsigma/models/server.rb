require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class Server < Fog::Model
        identity :id, :aliases => 'uuid'

        attribute :status, :type => :string
        attribute :vnc_password, :type => :string
        attribute :name, :type => :string
        attribute :cpus_instead_of_cores, :type => :boolean
        attribute :tags
        attribute :mem, :type => :integer
        attribute :nics
        attribute :enable_numa, :type => :boolean
        attribute :volumes, :type => :array, :aliases => 'drives'
        attribute :smp
        attribute :hv_relaxed, :type => :boolean
        attribute :hv_tsc, :type => :boolean
        attribute :meta
        attribute :owner
        attribute :runtime
        attribute :cpu, :type => :integer
        attribute :resource_uri, :type => :string


        def volumes
          volume_attrs = attributes[:drives] || []
          refreshed_vols = volume_attrs.map { |v| MountPoint.new(v) }
          #Save back to attributes so that the attributes of Server are the same objects as the volume attributes, so
          #that updating volumes updates the parent attributes
          attributes[:drives] = refreshed_vols.map { |v| v.attributes }

          refreshed_vols
        end

        def volumes=(new_volumes)
          new_volumes ||= []
          attributes[:drives] = new_volumes.map { |v| v.kind_of?(Hash) ? v : v.attributes }
        end

        def nics
          nics_attrs = attributes[:nics] || []
          refreshed_nics = nics_attrs.map { |n| Nic.new(n) }
          #Save back to attributes so that the attributes of Server are the same objects as the nic attributes, so
          #that updating nics updates the parent attributes
          attributes[:nics] = refreshed_nics.map { |n| n.attributes }

          refreshed_nics
        end

        def nics=(new_nics)
          new_nics ||= []
          attributes[:nics] = new_nics.map { |n| n.kind_of?(Hash) ? n : n.attributes }
        end

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

              'drives' => attributes[:drives] || [],
              'nics' => attributes[:nics] || [],
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

              'drives' => attributes[:drives] || [],
              'nics' => attributes[:nics] || [],
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

        def open_vnc
          requires :identity
          service.open_vnc(identity)
        end

        def close_vnc
          requires :identity
          service.close_vnc(identity)
        end

        def clone(clone_params={})
          requires :identity
          response = service.clone_server(identity, clone_params)

          self.class.new(response.body)
        end

        def mount_volume(volume, device = 'virtio', dev_channel = nil, boot_order = nil)
          unless dev_channel
            specified_channels = self.volumes.map { |v| v.dev_channel }.sort
            if specified_channels
              controller, controller_channel = 0, 0
              max_ctlr, max_chnl = case device
                                     when 'ide'
                                       [4, 2]
                                     else
                                       [1024, 5]
                                   end

              dev_channel = "#{controller}:#{controller_channel}"
              while specified_channels.include? dev_channel
                controller_channel += 1
                if controller_channel >= max_chnl
                  controller_channel = 0
                  controller += 1
                  if controller >= max_ctlr
                    raise "Max channel reached, cannot attach more" #TODO: Better exception
                  end
                end
                dev_channel = "#{controller}:#{controller_channel}"
              end
            else # no other channels specified
              dev_channel = '0:0'
            end
          end


          vol_id = volume.kind_of?(String) ? volume : volume.identity
          mountpoint_data = {
              'drive' => vol_id,
              'device' => device,
              'dev_channel' => dev_channel,
          }

          if boot_order
            mountpoint_data['boot_order'] = boot_order
          end

          self.volumes = self.volumes << MountPoint.new(mountpoint_data)
        end

        def unmount_volume(volume_or_position)
          if volume_or_position.kind_of? Fixnum
            self.volumes.delete_at(volume_or_position)
            # assign to update attributes
            return self.volumes = self.volumes
          end

          vol_id = volume_or_position.kind_of?(String) ? volume_or_position : volume_or_position.identity
          self.volumes = self.volumes.reject do |v|
            if v.volume.kind_of? Hash
              v.volume['uuid'] == vol_id
            else
              v.volume == vol_id
            end
          end
        end

        def unmount_all_volumes
          self.volumes = []
        end

        def add_nic(vlan=nil, ip_v4_conf=nil, ip_v6_conf=nil, model='virtio', boot_order=nil)
          nic_data = {
              'model' => model,
              'vlan' => vlan,
              'ip_v4_conf' => ip_v4_conf,
              'ip_v6_conf' => ip_v6_conf
          }
          if boot_order
            nic_data['boot_order'] = boot_order
          end

          self.nics = self.nics << Nic.new(nic_data)
        end

        def add_public_nic(ip_or_conf=:dhcp, model='virtio', boot_order=nil)
          case ip_or_conf
            when :dhcp
              add_nic(nil, {:conf => :dhcp}, model, boot_order)
            when :manual
              add_nic(nil, {:conf => :manual}, model, boot_order)
            else
              ip = ip_or_conf.kind_of?(String) ? ip_or_conf : ip_or_conf.ip
              add_nic(nil, {:conf => :static, :ip => ip}, nil, model, boot_order)
          end
        end

        def add_private_nic(vlan, model='virtio', boot_order=nil)
          vlan = vlan.kind_of?(String) ? vlan : vlan.id
          add_nic(vlan, nil, nil, model, boot_order)
        end

        def remove_nic(mac_or_position)
          if mac_or_position.kind_of? Fixnum
            self.nics.delete_at(mac_or_position)
            # assign to update attributes
            return self.nics = self.nics
          end

          self.nics = self.nics.reject { |n| n.mac == mac_or_position }
        end

        def remove_all_nics
          self.nics = []
        end
      end
    end
  end
end