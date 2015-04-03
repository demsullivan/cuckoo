# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 7) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at"
    t.text     "content"
    t.integer  "notable_id"
    t.string   "notable_type"
  end

  add_index "notes", ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.string  "external_system"
    t.integer "external_project_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string  "external_task_id"
    t.string  "name"
    t.text    "tags",             array: true
    t.integer "project_id"
    t.integer "estimate_seconds"
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "time_entries", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "tags",        array: true
    t.integer  "task_id"
    t.integer  "duration"
  end

  add_index "time_entries", ["task_id"], name: "index_time_entries_on_task_id", using: :btree

end
