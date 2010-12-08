require 'bundler'
Bundler.setup(:default)

require 'sinatra'
require 'sinatra/mongoid'
require 'gravtastic'
require 'mongoid'

require 'punchcard/person'
require 'punchcard/punch'
require 'punchcard/mongohq'

class Punchcard < Sinatra::Base
  set :views,  File.join(File.dirname(__FILE__), 'views')
  set :public, File.join(File.dirname(__FILE__), 'public')
  
  get '/' do
    haml :index
  end
  
  get '/status.json' do
    Person.order_by(:name).all.to_json
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