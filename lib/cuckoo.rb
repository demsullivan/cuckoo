require "cuckoo/version"
require "cuckoo/config"
#require "cuckoo/parser"

require "readline"

module Cuckoo
  class App

    def initialize
      load_config_file
      setup_db
      setup_api_connections
      setup_parser
    end
    
    def run!
      while line = Readline.readline('> ', true)
        p line
      end
    end

    ################################################################################
    private
    ################################################################################

    def load_config_file
      require File.expand_path("~/.Cuckoofile")      
    end

   
    def setup_db
      require 'activerecord'

      # load AR models
      Dir.glob('./cuckoo/models/*.rb').each do |file|
        require file
      end

      # connect to database
      ActiveRecord::Base.establish_connection(
        :adapter  => Config.config['adapter'],
        :database => Config.config['database']
      )
    end

    def setup_api_connections
    end

    def setup_parser
    end
    
    
  end
end
