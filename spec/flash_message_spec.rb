require 'spec_helper'
require './app/flash_message_service'

describe 'Flash Message Service' do
  before(:each) do
    authorize 'web_service_user', 'thenitdoesntreallymatter'
  end
  
  after(:each) do
    FlashMessage.delete_all
  end

  it 'should create a flash message' do
    message = { message: 'Test Message' }
    post '/messages/.json', message.to_json
    response = parse_json(last_response.body)
    response[:message].should eq(message[:message])
  end

  it 'should get a particular flash message' do
    message = create(:flash_message)
    get "/messages/#{message.id}.json"
    response = parse_json(last_response.body)
    response[:message].should eq(message[:message])
  end

  it 'should update a flash message' do
    message = create(:flash_message)
    put "/messages/#{message.id}.json", { message: 'New Test Message' }.to_json
    response = parse_json(last_response.body)
    response[:message].should eq('New Test Message')
  end

  it 'should delete a flash message' do
    message = create(:flash_message)
    delete "/messages/#{message.id}.json"
    response = parse_json(last_response.body)
    response[:deleted].should eq(true)
    FlashMessage.where(id: message.id).exists?.should eq(false)
  end

  it 'should return the flash messages' do
    mess1 = create(:flash_message, message: 'Message 1')
    mess2 = create(:flash_message, message: 'Message 2')
    get '/messages/.json'
    response = parse_json(last_response.body)
    response[0][:message].should eq(mess1[:message])
  end
end