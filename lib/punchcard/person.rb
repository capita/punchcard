class Person < ActiveRecord::Base
  # include Mongoid::Document
  # 
  # field :name
  # field :email
  # 
  # index :name, :unique => true
  # 
  # embeds_many :punches
  
  has_many :punches
  
  validates_presence_of :name, :email
  
  include Gravtastic
  has_gravatar
  
  # Returns the currently pending punch when present, nil otherwise
  def pending?
    punches.pending.count > 0 ? punches.pending.first : nil
  end
  
  # Punches in when no punches pending, punches out when a pending punch exists!
  # When punching in, checks whether a recently finished punch exists and reopens if so instead
  # of creating a new punch
  def punch!
    if punch = pending?
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