FactoryGirl.define do
  factory :flash_message do
    message 'Test Message'
    application_ids ['1', '2']
    organization_ids ['32', '34']
    expiration Time.now + 3600
    created_by '007'
  end
end