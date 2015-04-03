class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.datetime   :created_at
      t.text       :content
      t.references :notable, polymorphic: true, index: true
    end
  end
end
