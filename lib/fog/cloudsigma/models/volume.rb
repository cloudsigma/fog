require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class Volume < Fog::Model
        identity :id, :aliases => 'uuid'

        attribute :status, :type => :string
        attribute :jobs
        attribute :name, :type => :string
        attribute :tags
        attribute :media, :type => :string
        attribute :mounted_on
        attribute :owner
        attribute :meta
        attribute :allow_multimount, :type => :boolean
        attribute :licenses
        attribute :affinities, :type => :array
        attribute :size, :type => :integer
        attribute :resource_uri, :type => :string


        def save
          if persisted?
            update
          else
            create
          end
        end

        def create
          requires :name, :size, :media
          data = {
              'name' => name,
              'size' => size,
              'media' => media,
              'affinities' => affinities || [],
              'meta' => meta || {},
              'tags' => tags || [],
              'allow_multimount' => false
          }

          response = service.create_volume(data)
          new_attributes = response.body['objects'].first
          merge_attributes(new_attributes)
        end

        def update
          requires :identity, :name, :size, :media

          data = {
              'name' => name,
              'size' => size,
              'media' => media,
              'affinities' => affinities || [],
              'meta' => meta || {},
              'tags' => tags || [],
              'allow_multimount' => false
          }

          response = service.update_volume(identity, data)
          new_attributes = response.body
          merge_attributes(new_attributes)

        end

        def destroy
          requires :identity

          service.delete_volume(identity)

          true
        end

        alias :delete :destroy

        def reload
          requires :identity
          collection.get(identity)
        end
      end
    end
  end
end