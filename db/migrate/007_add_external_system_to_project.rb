class AddExternalSystemToProject < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string  :external_system,     null: true
      t.integer :external_project_id, null: true
    end
  end
end
