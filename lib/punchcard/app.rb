class Punchcard::App < Sinatra::Base
  set :views,  File.join(File.dirname(__FILE__), '../views')
  set :public, File.join(File.dirname(__FILE__), '../public')
  
  get '/' do
    haml :index
  end
  
  get '/status.json' do
    {:people => Person.order('name ASC').map(&:payload)}.to_json
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