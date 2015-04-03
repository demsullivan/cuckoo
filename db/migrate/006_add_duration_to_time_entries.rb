class AddDurationToTimeEntries < ActiveRecord::Migration
  def change
    change_table :time_entries do |t|
      t.integer :duration
    end
  end
end
