require "cuckoo/pivotal/version"
require "pivotal-tracker"

module Cuckoo
  module Pivotal
    class Plugin < Cuckoo::ExternalSystemPlugin

      def initialize(config)
        @config = config
        PivotalTracker::Client.token = @config.api_token
      end

      ################################################################################
      private
      ################################################################################
      def sync_tasks_from(projects)
        projects.each do |project|
          pivotal_project = PivotalTracker::Project.find(project.external_project_id)

          pivotal_project.stories.all.each do |story|
            unless story.current_state == 'accepted'
              task = project.tasks.where(:external_task_id => story.id)
              Task.new(:project => project, :external_task_id => story.id, :name => story.name).save! unless task.any?
            end
            # TODO: cleanup already synced accepted tasks
          end
        end
      end

      def get_projects_from_pivotal
        new_projects = []
        
        projects = PivotalTracker::Project.all
        puts "It looks like this is your first time setting up cuckoo-pivotal."
        projects.each do |p|
          puts "Enter a Cuckoo project code for '#{p.name}' or ENTER to skip: "
          code = gets
          next if code == '\n'
          new_projects << new_project(p.id, code.chomp)
        end

        new_projects
      end
    end

    class ConfigFactory < Cuckoo::PluginConfigFactory
      attr_accessor :api_token
    end
    
  end
end
