module Cuckoo
  module Commands
    class NewTaskCommand

      include Cuckoo::Models

      attr_accessor :update_context

      def call(args)
        @context        = args[:context]
        @cmd_context    = args[:cmd_context]
        @update_context = args[:update_context]

        unless @context.timer.nil? and @context.time_entry.nil?
          @context.time_entry.finished_at = DateTime.now
          @context.time_entry.save!
        end

        @context.timer = Timer.new(3600, true)

        @context.project = Project.find_or_create_by(:code => @cmd_context.project)

        if @cmd_context.has_taskid?
          @context.task = @context.project.tasks.where("tasks.external_task_id = :taskid", {taskid: @cmd_context.taskid}).first
        else
          @context.task = Task.new(:name => @cmd_context.task, :external_task_id => @cmd_context.taskid,
                                   :project => project, :estimate_seconds => @cmd_context.estimate)
        end

        @context.time_entry = TimeEntry.new(:task => @context.task, :tags => @cmd_context.tags,
                                            :started_at => DateTime.now)

        @context.project.save!
        @context.task.save!
        @context.time_entry.save!
        
        if @context.task.external_task_id.nil?
          @context.task.external_task_id = @context.task.id.to_s
          @context.task.save!
        end
        

        
        @update_context = true

        puts "Started timer for ##{@context.task.external_task_id} #{@context.task.name} on project #{@context.project.code}."
      end
    end
  end
end
