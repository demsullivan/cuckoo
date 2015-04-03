module Cuckoo
  class CommandInput
    
    include Commands
    
    COMMANDS = {
      :create         => {
        :cmd        => CreateCommand,
        :conditions => Proc.new {|c| c.cmd.split(' ').first.downcase == 'create'}
      },
      
      :status         => {
        :cmd        => StatusCommand,
        :conditions => Proc.new {|c| c.cmd.split(' ').first.downcase == 'status'}
      },
      
      :stop           => {
        :cmd        => StopCommand,
        :conditions => Proc.new {|c| c.cmd.split(' ').first.downcase == 'stop'}
      },

      :add_note       => {
        :cmd        => AddNoteCommand,
        :conditions => Proc.new {|c| c.cmd.split(' ').first.downcase == 'note' }
      },

      :irb            => {
        :cmd        => IRBCommand,
        :conditions => Proc.new {|c| c.cmd.split(' ').first.downcase == 'irb' }
      },
      
      :new_task       => {
        :cmd        => NewTaskCommand,
        :conditions => Proc.new {|c| c.has_project? and c.has_task? and not c.has_date? and not c.has_duration? and not c.has_taskid? }
      },
      
      :update_task    => {
        :cmd        => UpdateTaskCommand,
        :conditions => Proc.new {|c| (c.has_project? and (c.has_task? or c.has_taskid?)) or (c.has_date? or c.has_duration?) }
      }
    }

    attr_accessor :context
    
    def initialize(line, context)
      @line    = line
      @context = context

      @parser          = Parser.new
      @cmd_context     = @parser.parse(@line)
      @cmd_context.cmd = @line
    end

    def execute!
      args = {
        :context        => @context,
        :cmd_context    => @cmd_context,
        :update_context => false,
      }

      COMMANDS.each do |cmd, config|
        condition_check = config[:conditions]
        next if condition_check.nil?
        
        if condition_check.call @cmd_context
          config[:cmd].new.call(args)
          break
        end
      end
      
    end

  end
end
