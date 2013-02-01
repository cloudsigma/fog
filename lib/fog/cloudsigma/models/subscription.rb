require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class Subscription < Fog::Model
        identity :id

        attribute :status, :type => :string
        attribute :uuid, :type => :string
        attribute :resource, :type => :string
        attribute :auto_renew, :type => :boolean
        attribute :descendants
        attribute :start_time, :type => :time
        attribute :price, :type => :float
        attribute :period, :type => :string
        attribute :remaining, :type => :string
        attribute :amount, :type => :string
        attribute :end_time, :type => :time
        attribute :discount_percent, :type => :float
        attribute :subscribed_object, :type => :string
        attribute :discount_amount, :type => :float

      end
    end
  end
end
