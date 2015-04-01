require 'skywalker/command'

module Cuckoo
  module Commands
    class StatusCommand < Skywalker::Command

      attr_accessor :update_context
      
      def execute!
        unless context.timer.nil?
          elapsed_string = ChronicDuration.output(context.timer.elapsed, :format => :long)
          puts "Working on '#{context.project}' '#{context.task}' for #{elapsed_string}."
        else
          puts "No timers running."
        end
      end

      private def required_args
        %w(context cmd_context update_context on_success on_failure)
      end
    end
  end
end
