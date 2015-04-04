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
      def all_pivotal_projects
        PivotalTracker::Project.all
      end

      def project_name_for(p)
        p.name
      end

      def project_id_for(p)
        p.id
      end
      
      def sync_tasks_from(projects)
        projects.each do |project|
          pivotal_project = PivotalTracker::Project.find(project.external_project_id)

          pivotal_project.stories.all.each do |story|
            unless story.current_state == 'accepted'
              task = project.tasks.where(:external_task_id => story.id)
              Task.create(:project => project, :external_task_id => story.id, :name => story.name) unless task.any?
            end
            # TODO: cleanup already synced accepted tasks
          end
        end
      end
    end

    class ConfigFactory < Cuckoo::PluginConfigFactory
      attr_accessor :api_token
    end
    
  end
end
