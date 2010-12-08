# Automagic Mongo db autosetup for heroku & mongohq
if ENV['MONGOHQ_URL']
  require 'uri'
  mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
  ENV['MONGOID_HOST'] = mongo_uri.host
  ENV['MONGOID_PORT'] = mongo_uri.port.to_s
  ENV['MONGOID_USERNAME'] = mongo_uri.user
  ENV['MONGOID_PASSWORD'] = mongo_uri.password
  ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "")
end