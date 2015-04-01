require 'skywalker/command'

module Cuckoo
  module Commands
    class NewTaskCommand < Skywalker::Command
      
      attr_accessor :update_context
      
      def execute!
        unless context.timer.nil?
          puts "Timer already running."
          return
        end

        context.timer = Timer.new(3600, true)
        puts "create task called '#{cmd_context.task}'"
        @update_context = true
      end
      
      private def required_args
        %w(context cmd_context update_context on_success on_failure)
      end
    end
  end
end
