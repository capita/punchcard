class Person < ActiveRecord::Base
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
      if recently_finished = punches.finished.first and recently_finished.checked_out_at.utc > 30.minutes.ago.utc
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
      :checked_in_at => pending? ? pending?.checked_in_at.getutc.iso8601 : nil
    }
  end
  
  def to_json(*args)
    payload.to_json
  end
end