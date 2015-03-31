require 'skywalker/command'

module Cuckoo
  module Commands
    class NewTaskCommand < Skywalker::Command
      def execute!
        unless context.timer.nil?
          puts "Timer already running."
        end

        context.timer = Timer.new(2, true)
          
        puts "create task called '#{context.task}'"
      end
      
      private def required_args
        %w(context on_success on_failure)
      end
    end
  end
end
