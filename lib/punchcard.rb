require 'bundler'
Bundler.setup(:default)

require 'sinatra'
require 'gravtastic'
require 'active_record'

require 'logger'
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = Logger::WARN
ActiveRecord::Migration.verbose = false

# Heroku-deployed apps will have this
if File.exist?('config/database.yml')
  dbconfig = YAML.load(File.read('config/database.yml'))
  ActiveRecord::Base.establish_connection dbconfig[ENV['RACK_ENV']]
else
  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "punchcard_#{ENV['RACK_ENV'] || 'development'}.sqlite3")
end

require 'punchcard/person'
require 'punchcard/punch'

module Punchcard
end

require 'punchcard/app'
require 'punchcard/version'