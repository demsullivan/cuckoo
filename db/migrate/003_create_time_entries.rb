class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.datetime   :started_at
      t.datetime   :finished_at
      t.text       :tags, array: true
      t.belongs_to :task, index: true
  end
end
