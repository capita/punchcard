require 'bundler'
Bundler.setup(:default)

require 'sinatra'
require 'gravtastic'
require 'active_record'

require 'logger'
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = Logger::WARN
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || {:adapter => 'sqlite3', :database => "punchcard_#{ENV['RACK_ENV'] || 'development'}.sqlite3"})

require 'punchcard/person'
require 'punchcard/punch'

class Punchcard < Sinatra::Base
  set :views,  File.join(File.dirname(__FILE__), 'views')
  set :public, File.join(File.dirname(__FILE__), 'public')
  
  get '/' do
    haml :index
  end
  
  get '/status.json' do
    Person.order('name ASC').map(&:payload).to_json
  end
  
  post '/punch/:id' do
    @person = Person.find(params[:id])
    @person.punch!
    @person.to_json
  end
  
  get '/css/screen.css' do
    sass :screen
  end
end