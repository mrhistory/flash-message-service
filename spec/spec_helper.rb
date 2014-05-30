ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'factory_girl'
require 'factories'
require 'json'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
end

def app
  Sinatra::Application
end

def parse_json(json)
  JSON.parse(json, symbolize_names: true)
end