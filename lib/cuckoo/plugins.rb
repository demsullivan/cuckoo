module Cuckoo
  class ExternalSystemPlugin

    include Cuckoo::Models

    def sync_tasks
      linked_projects = Project.where(:external_system => @config.plugin_name)

      if linked_projects.any?
        sync_tasks_from linked_projects
      else
        sync_tasks_from initial_setup
      end
    end

    ################################################################################
    private
    ################################################################################
    def new_project(id, code)
      Project.create(:code => code, :external_system => @config.plugin_name,
                     :external_project_id => id)
    end

    def project_name_for(p)
      p.name
    end

    def project_id_for(p)
      p.id
    end
    
    def initial_setup
      new_projects = []

      projects = send("all_#{@config.plugin_name}_projects")

      puts "It looks like this is your first time using the #{@config.plugin_name} plugin."
      puts "Let's quickly sync the projects with Cuckoo."

      projects.each do |p|
        print "Enter a Cuckoo project code for #{project_name_for(p)} or ENTER to skip: "
        code = gets

        next if code == '\n'
        new_projects << new_project(project_id_for(p), code.chomp)
      end

      new_projects
    end
    
  end

  class PluginConfigFactory
    attr_accessor :plugin_name
    
    def initialize(plugin_name)
      @plugin_name = plugin_name
    end
  end
  
end
