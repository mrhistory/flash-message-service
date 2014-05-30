require 'mongoid'

class FlashMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message
  field :application_ids, type: Array
  field :organization_ids, type: Array
  field :expiration, type: Time
  field :created_by

  validates_presence_of :message
end