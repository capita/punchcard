require 'bundler'
Bundler.require(:default)

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

class Person
  include Mongoid::Document

  field :name
  field :email
  
  index :name, :unique => true
  
  embeds_many :punches
  
  validates_presence_of :name, :email
  
  include Gravtastic
  has_gravatar
  
  # Returns the currently pending punch when present, nil otherwise
  def pending?
    punches.pending.first
  end
  
  # Punches in when no punches pending, punches out when a pending punch exists!
  # When punching in, checks whether a recently finished punch exists and reopens if so instead
  # of creating a new punch
  def punch!
    if punch = punches.pending.first
      punch.punch_out!
    else
      if recently_finished = punches.recently_finished.first
        recently_finished.reopen!
      else
        punches.create!
      end
    end
  end
  
  def payload
    {
      :_id => id,
      :name => name, 
      :email => email, 
      :gravatar_url => gravatar_url(:size => 80), 
      :pending => !!pending?, 
      :checked_in_at => pending?.try(:checked_in_at)
    }
  end
  
  def to_json(*args)
    payload.to_json
  end
end

class Punch
  include Mongoid::Document
  field :checked_in_at, :type => Time
  field :checked_out_at, :type => Time
  
  embedded_in :person, :inverse_of => :punches
  
  scope :pending, where(:checked_out_at.exists => false)
  scope :finished, where(:checked_out_at.exists => true, :checked_in_at.exists => true)
  scope :recently_finished, where(:checked_out_at.gt => 30.minutes.ago)
  
  validates_presence_of :checked_in_at
  
  before_validation do |p|
    p.checked_in_at ||= Time.now
  end
  
  validate do |p|
    p.errors.add :person, "Person already has a pending punch!" if p.person.pending? and p.person.pending? != p
  end
  
  # Punches this punch out when pending
  def punch_out!
    return false if checked_out_at.present?
    # Make sure no one stays the night...
    if self.checked_in_at.to_date < Date.today
      self.checked_out_at = self.checked_in_at.end_of_day
    else
      self.checked_out_at = Time.now
    end
    save!
    self
  end
  
  def reopen!
    self.checked_out_at = nil
    save!
    self
  end
end

# Magic Mongo db autosetup for heroku & mongohq
if ENV['MONGOHQ_URL']
  require 'uri'
  mongo_uri = URI.parse(ENV['MONGOHQ_URL'])
  ENV['MONGOID_HOST'] = mongo_uri.host
  ENV['MONGOID_PORT'] = mongo_uri.port.to_s
  ENV['MONGOID_USERNAME'] = mongo_uri.user
  ENV['MONGOID_PASSWORD'] = mongo_uri.password
  ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "")
end
