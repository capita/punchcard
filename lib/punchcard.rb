require 'bundler'
Bundler.require

class Punchcard < Sinatra::Base
  set :views,  File.join(File.dirname(__FILE__), 'views')
  set :public, File.join(File.dirname(__FILE__), 'public')
  
  get '/' do
    haml :index
  end
  
  get '/css/screen.css' do
    sass :screen
  end
end