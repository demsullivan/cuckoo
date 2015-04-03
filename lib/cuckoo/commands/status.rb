module Cuckoo
  module Commands
    class StatusCommand

      attr_accessor :update_context

      def call(args)
        @context        = args[:context]
        @cmd_context    = args[:cmd_context]
        @update_context = args[:update_context]

        unless @context.timer.nil?
          elapsed_string = ChronicDuration.output(@context.timer.elapsed, :format => :long)
          puts "Working on '#{@context.project.code}' '#{@context.task.name}' for #{elapsed_string}."
        else
          puts "No timers running."
        end
      end
    end
  end
end
