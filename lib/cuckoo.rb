require "readline"
require "thread"

require "pry"
require "celluloid/autostart"
require "active_record"
require "pg"
require "logger"

require "cuckoo/version"
require "cuckoo/config"

require "cuckoo/tags/prefixed_word"
require "cuckoo/tags/project"
require "cuckoo/tags/tag"
require "cuckoo/tags/taskid"
require "cuckoo/tags/time"
require "cuckoo/token"
require "cuckoo/parser"

require "cuckoo/models/project"
require "cuckoo/models/task"
require "cuckoo/models/time_entry"
require "cuckoo/models/note"

require "cuckoo/commands/create"
require "cuckoo/commands/new_task"
require "cuckoo/commands/update_task"
require "cuckoo/commands/status"
require "cuckoo/commands/stop"
require "cuckoo/commands/add_note"
require "cuckoo/commands/irb"
require "cuckoo/command_input"

require "cuckoo/completer"
require "cuckoo/context"
require "cuckoo/timer"

require "cuckoo/plugins"

module Cuckoo
  class InputActor
    include Celluloid

    attr_accessor :text, :running
    
    def read_input
      @text = Readline.readline('cko> ', true)
    end
  end
  
  class App
    include Celluloid
    include Celluloid::Notifications

    def initialize
      load_config_file
      setup_db
      setup_api_connections
      setup_context

      subscribe "timer_complete", :on_timer_complete
    end

    def on_timer_complete(topic, data="")
      Actor.kill(@input)
      puts ""
      puts "Timer complete!"
      @context.timer = nil
    end
    
    def run!
      @input = InputActor.new
      @break_count = 0
      
      while 1
        begin
          unless @input.running
            break if @break_count == 2
            @input.async.read_input
            @break_count += 1 if @input.text.nil?
            puts "Hit ^D again to exit." if @input.text.nil? and @break_count == 1
          end

          
          unless @input.text.nil?
            command = CommandInput.new(@input.text, @context)
            @break_count = 0
            
            begin
              command.execute!
            rescue Exception => e
              puts e.message
              next
            end
            
            @context = command.context
          end
        rescue DeadActorError
          @input = InputActor.new
        end
        
      end

      @input.terminate if @input.running
      terminate
      
    end

    ################################################################################
    private
    ################################################################################

    def load_config_file
     load File.expand_path("~/.Cuckoofile")      
    end
   
    def setup_db


      # TODO: make log file configurable
      ActiveRecord::Base.logger = ::Logger.new('debug.log')

      # load AR models


      # connect to database
      config = YAML::load(IO.read('config/database.yml'))
      ActiveRecord::Base.establish_connection(config['development'])
    end

    def setup_api_connections
      Cuckoo::Config.config.plugins.each do |name, plugin|
        if plugin.respond_to? :sync_tasks
          plugin.sync_tasks
        end
      end
    end

    def setup_context
      @context = Context.new
      Readline.completion_proc = Completer.new

      # we want to pass the whole line to the completion method, not just
      # the last word, so it can understand the context.
      Readline.completer_word_break_characters = ""
    end
    
    
  end
end
