require "bundler/gem_tasks"
require 'bundler/setup'
require 'active_record'
require 'cuckoo'

include ActiveRecord::Tasks

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  raise
end

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(File.read(File.join(config_dir, 'database.yml')))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')
 
task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env
end
 
load 'active_record/railties/databases.rake'


task :console => [:environment] do
  app = Cuckoo::App.new
  include Cuckoo::Models
  require 'irb'
  ARGV.clear
  IRB.start
end
