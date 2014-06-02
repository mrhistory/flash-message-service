require 'sinatra'
require 'mongoid'
require 'json'
require './config/settings'
require './app/models'

Mongoid.load!('./config/mongoid.yml')

before do
  content_type :json
  ssl_whitelist = ['/calendar.ics']
  if settings.force_ssl && !request.secure? && !ssl_whitelist.include?(request.path_info)
    halt 400, "Please use SSL at https://#{settings.host}"
  end
end

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'web_service_user' and password == 'thenitdoesntreallymatter'
end

get '/' do
  'Welcome to the Flash Message Service!'
end

get '/messages/.json' do
  begin
    FlashMessage.all.to_json
  rescue Exception => e
    halt 500, e.message
  end
end

get "/messages/:organization/:application/:expired?/.json" do
  begin
    FlashMessage.search(params[:organization], params[:application], params[:expired?]).to_json
  rescue Exception => e
    halt 500, e.message
  end
end

post '/messages/.json' do
  begin
    message = FlashMessage.new(json_params)
    if message.save
      message.to_json
    else
      halt 500, message.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end

get '/messages/:id.json' do
  begin
    message = FlashMessage.find(params[:id])
    if message.nil?
      raise Exception, 'Flash Message not found.'
    else
      message.to_json
    end
  rescue Exception => e
    halt 500, e.message
  end
end

put '/messages/:id.json' do
  begin
    message = FlashMessage.find(params[:id])
    if message.update_attributes!(json_params)
      message.to_json
    else
      halt 500, message.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end

delete '/messages/:id.json' do
  begin
    message = FlashMessage.find(params[:id])
    if message.destroy
      { :id => message.id, :deleted => true }.to_json
    else
      halt 500, message.errors.full_messages[0]
    end
  rescue Exception => e
    halt 500, e.message
  end
end


private

def json_params
  JSON.parse(request.env['rack.input'].read, symbolize_names: true)
end