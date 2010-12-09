class CreatePunches < ActiveRecord::Migration
  def self.up
    create_table :punches do |t|
      t.integer  :person_id, :null => false
      t.datetime :checked_in_at, :null => false
      t.datetime :checked_out_at, :default => nil
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
