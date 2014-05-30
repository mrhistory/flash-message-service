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


private

def json_params
  JSON.parse(request.env['rack.input'].read, symbolize_names: true)
end