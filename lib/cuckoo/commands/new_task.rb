module Cuckoo
  module Commands
    class NewTaskCommand

      include Cuckoo::Models

      attr_accessor :update_context

      def call(args)
        @context        = args[:context]
        @cmd_context    = args[:cmd_context]
        @update_context = args[:update_context]

        unless @context.timer.nil?
          puts "Timer already running."
          return
        end

        @context.timer = Timer.new(3600, true)

        project = Project.where(:code => @cmd_context.project)

        if project.length == 0
          project = Project.new(:code => @cmd_context.project)
        else
          project = project.first
        end

        @context.project = project
        @context.task = Task.new(:name => @cmd_context.task, :external_task_id => @cmd_context.taskid,
                                 :project => project, :estimate_seconds => @cmd_context.estimate)

        @context.time_entry = TimeEntry.new(:task => @context.task, :tags => @cmd_context.tags,
                                            :started_at => DateTime.now)

        @context.project.save!
        
        @context.task.save!

        if @cmd_context.taskid.nil?
          @context.task.external_task_id = @context.task.id.to_s
          @context.task.save!
        end
        
        @context.time_entry.save!
        
        @update_context = true
        
        puts "Created task ##{@context.task.external_task_id} #{@context.task.name} on project #{@context.project.code}."
      end
    end
  end
end
