module Cuckoo
  class ExternalSystemPlugin

    include Cuckoo::Models

    def sync_tasks
      linked_projects = Project.where(:external_system => @config.plugin_name)

      if linked_projects.any?
        sync_tasks_from linked_projects
      else
        sync_tasks_from send("get_projects_from_#{@config.plugin_name}")
      end
    end

    ################################################################################
    private
    ################################################################################
    def new_project(id, code)
      Project.create(:code => code, :external_system => @config.plugin_name,
                     :external_project_id => id)
    end
  end

  class PluginConfigFactory
    attr_accessor :plugin_name
    
    def initialize(plugin_name)
      @plugin_name = plugin_name
    end
  end
  
end
