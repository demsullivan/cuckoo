require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
load File.expand_path('../../../db/schema.rb', __FILE__)
