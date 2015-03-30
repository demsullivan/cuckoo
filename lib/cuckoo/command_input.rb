module Cuckoo
  class CommandInput
    
    include Commands
    
    COMMANDS = {
      :new_task       => {
        :cmd        => NewTaskCommand,
        :conditions => Proc.new {|c| c.has_project? and c.has_task? and not c.has_date? and not c.has_duration? }
      },

      :update_current => {
        :cmd        => UpdateTaskCommand,
        :conditions => Proc.new {|c| c.has_date? or c.has_duration? }
      },
      
      :update_task    => {
        :cmd        => UpdateTaskCommand,
        :conditions => Proc.new {|c| c.has_project? and c.has_task? and (c.has_date? or c.has_duration?) }
      },
      
      :status         => { :cmd => StatusCommand },
      :stop           => { :cmd => StopCommand   }
    }

    attr_accessor :context
    
    def initialize(line, context)
      @line    = line
      @context = context

      @parser     = Parser.new
      new_context = @parser.parse(@line)

      @context.merge! new_context
    end

    def execute!
      args = {
        :context    => @context,
        :on_success => method(:on_command_success),
        :on_failure => method(:on_command_failure)
      }

      COMMANDS.each do |cmd, config|
        condition_check = config[:conditions]
        next if condition_check.nil?
        
        if condition_check.call @context
          config[:cmd].call(args)
          break
        end
      end
      
    end

    def on_command_success(command)
    end

    def on_command_failure(command)
      raise command.error
    end
  end
end
