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