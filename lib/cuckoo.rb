require "cuckoo/version"
require "cuckoo/config"

require "cuckoo/tags/prefixed_word"
require "cuckoo/tags/project"
require "cuckoo/tags/tag"
require "cuckoo/tags/taskid"
require "cuckoo/tags/time"
require "cuckoo/token"
require "cuckoo/parser"

require "cuckoo/commands/new_task"
require "cuckoo/commands/update_task"
require "cuckoo/commands/status"
require "cuckoo/commands/stop"
require "cuckoo/command_input"

require "cuckoo/completer"
require "cuckoo/context"

require "readline"
require "pry"

module Cuckoo
  class App

    def initialize
      load_config_file
      setup_db
      setup_api_connections
      setup_context
    end
    
    def run!
      while line = Readline.readline('> ', true)
        command = CommandInput.new(line, @context)

        begin
          command.execute!
        rescue Exception => e
          puts e.message
          next
        end
        
        @context = command.context
      end
    end

    ################################################################################
    private
    ################################################################################

    def load_config_file
      load File.expand_path("~/.Cuckoofile")      
    end
   
    def setup_db
      require 'active_record'
      require 'sqlite3'
      require 'logger'

      # TODO: make log file configurable
      ActiveRecord::Base.logger = Logger.new('debug.log')

      # load AR models
      Dir.glob('./cuckoo/models/*.rb').each do |file|
        require file
      end

      # connect to database
      ActiveRecord::Base.establish_connection(
        :adapter  => "sqlite3", #Config.config['adapter'],
        :database => File.expand_path("~/cuckoo.db"), #Config.config['database']
      )
    end

    def setup_api_connections
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
