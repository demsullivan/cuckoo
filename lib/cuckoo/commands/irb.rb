module Cuckoo
  module Commands
    class IRBCommand

      include Cuckoo::Models
      
      def call(args)
        
        require 'irb'
        ARGV.clear
        IRB.start
        
      end
    end
  end
end
