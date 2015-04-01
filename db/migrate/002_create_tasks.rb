class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer    :external_task_id
      t.string     :name
      t.text       :tags, array: true
      t.belongs_to :project, index: true
  end
end
