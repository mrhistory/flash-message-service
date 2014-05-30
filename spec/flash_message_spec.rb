require 'spec_helper'
require './app/flash_message_service'

describe 'Flash Message Service' do
  before(:each) do
    authorize 'web_service_user', 'thenitdoesntreallymatter'
  end
  
  after(:each) do
    FlashMessage.delete_all
  end
end