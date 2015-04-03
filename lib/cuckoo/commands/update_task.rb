module Cuckoo
  module Commands
    class UpdateTaskCommand

      include Cuckoo::Models
      
      attr_accessor :update_context
      
      def call(args)
        @context     = args[:context]
        @cmd_context = args[:cmd_context]

        if not @context.has_active_task? or (@cmd_context.has_project? and (@cmd_context.has_task? or @cmd_context.has_taskid?))
          update_other_task
        else
          update_current_task
        end
      end

      ################################################################################
      private
      ################################################################################

      def update_current_task
        # handle "X last 15 minutes" type cases
        if not @cmd_context.has_date? and @cmd_context.has_duration?
          if @context.time_entry.finished_at.nil?           
            @context.time_entry.finished_at = @cmd_context.duration.seconds.ago
            @context.time_entry.save!
          end
          
          time_entry = TimeEntry.new(:task => @context.task, :tags => @cmd_context.tags,
                                     :started_at => @cmd_context.duration.seconds.ago,
                                     :finished_at => DateTime.now)
          time_entry.save!

          @context.time_entry = TimeEntry.new(:task => @context.task, :tags => @context.time_entry.tags,
                                              :started_at => DateTime.now)
          @context.time_entry.save!

        end

        puts "updated current task"
            
            
      end

      def update_other_task
        task = Task.joins(:project).where(:projects => {:code => @cmd_context.project}).
               where("external_task_id = :taskid", {:taskid => @cmd_context.taskid}).first

        entry = TimeEntry.new(:task => task, :tags => @cmd_context.tags,
                              :started_at => @cmd_context.date,
                              :finished_at => @cmd_context.duration.seconds.since(@cmd_context.date))
        entry.save!
      end
      
    end
  end
end
