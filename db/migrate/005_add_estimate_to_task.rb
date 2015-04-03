class AddEstimateToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.integer :estimate_seconds
    end
  end
end
