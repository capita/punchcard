class Punch < ActiveRecord::Base
  belongs_to :person

  validates_presence_of :checked_in_at
  
  scope :pending, where("checked_out_at IS NULL").order("checked_in_at ASC")
  scope :finished, where("checked_in_at IS NOT NULL AND checked_out_at IS NOT NULL").order('checked_out_at DESC')
  
  before_validation do |p|
    p.checked_in_at ||= Time.now.utc
  end
  
  validate do |p|
    p.errors.add :person, "Person already has a pending punch!" if p.person.pending? and p.person.pending? != p
  end
  
  after_save do |p|
    # Destroy punches shorter than 5 minutes
    if p.checked_out_at.present? and (p.checked_out_at - p.checked_in_at) < 5.minutes
      p.destroy
    end
  end
  
  # Punches this punch out when pending
  def punch_out!
    return false if checked_out_at.present?
    # Make sure no one stays the night...
    if self.checked_in_at.utc < Time.now.utc.beginning_of_day
      self.checked_out_at = self.checked_in_at.utc.end_of_day
    else
      self.checked_out_at = Time.now.utc
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