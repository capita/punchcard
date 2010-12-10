class AddMinutesToPunches < ActiveRecord::Migration
  def self.up
    add_column :punches, :minutes, :integer, :default => 0
    Punch.all.each do |p|
      p.save!
    end
  end

  def self.down
    remove_column :punches, :minutes, :integer
  end
end
