require 'mongoid'

class FlashMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message
  field :application_ids, type: Array
  field :organization_ids, type: Array
  field :expiration, type: DateTime
  field :created_by

  validates_presence_of :message

  def self.search(organization, application, include_expired)
    if include_expired.downcase == 'true'
      where( { organization_ids: organization, application_ids: application })
    else
      where( { organization_ids: organization, application_ids: application, :expiration.gt => Time.now })
    end
  end
end