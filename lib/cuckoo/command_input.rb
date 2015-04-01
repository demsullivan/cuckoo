module Cuckoo
  class CommandInput
    
    include Commands
    
    COMMANDS = {
      :status         => {
        :cmd        => StatusCommand,
        :conditions => Proc.new {|t, c| t.split(' ').first.downcase == 'status'}
      },
      
      :stop           => {
        :cmd        => StopCommand,
        :conditions => Proc.new {|t, c| t.split(' ').first.downcase == 'stop'}
      },
            
      :new_task       => {
        :cmd        => NewTaskCommand,
        :conditions => Proc.new {|t, c| c.has_project? and c.has_task? and not c.has_date? and not c.has_duration? and not c.has_taskid? }
      },

      :update_current => {
        :cmd        => UpdateTaskCommand,
        :conditions => Proc.new {|t, c| c.has_date? or c.has_duration? }
      },
      
      :update_task    => {
        :cmd        => UpdateTaskCommand,
        :conditions => Proc.new {|t, c| c.has_project? and (c.has_task? or c.has_taskid?) and (c.has_date? or c.has_duration?) }
      }
    }

    attr_accessor :context
    
    def initialize(line, context)
      @line    = line
      @context = context

      @parser     = Parser.new
      @cmd_context = @parser.parse(@line)
    end

    def execute!
      args = {
        :context        => @context,
        :cmd_context    => @cmd_context,
        :update_context => false,
        :on_success     => method(:on_command_success),
        :on_failure     => method(:on_command_failure)
      }

      COMMANDS.each do |cmd, config|
        condition_check = config[:conditions]
        next if condition_check.nil?
        
        if condition_check.call @line, @cmd_context
          config[:cmd].call(args)
          break
        end
      end
      
    end

    def on_command_success(command)
      if command.update_context
        @context.merge! @cmd_context
      end
    end

    def on_command_failure(command)
      raise command.error
    end
  end
end
