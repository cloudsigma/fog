require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class Nic < Fog::Model
        attribute :boot_order, :type => :integer
        attribute :vlan
        attribute :ip_v4_conf
        attribute :mac, :type => :string
        attribute :model, :type => :string
        attribute :ip_v6_conf

        def ip_v4_conf
          if attributes[:ip_v4_conf]
            refreshed_conf = IPConf.new(attributes[:ip_v4_conf])
            attributes[:ip_v4_conf] = refreshed_conf.attributes
            
            refreshed_conf
          else
            nil
          end
        end

        def ip_v4_conf=(new_conf)
          if new_conf
           attributes[:ip_v4_conf] = new_conf.kind_of?(Hash) ? new_conf : new_conf.attributes
          end
        end

        def ip_v6_conf
          if attributes[:ip_v6_conf]
            refreshed_conf = IPConf.new(attributes[:ip_v6_conf])
            attributes[:ip_v6_conf] = refreshed_conf.attributes

            refreshed_conf
          else
            nil
          end
        end

        def ip_v6_conf=(new_conf)
          if new_conf
            attributes[:ip_v6_conf] = new_conf.kind_of?(Hash) ? new_conf : new_conf.attributes
          end
        end

      end
    end
  end
end
