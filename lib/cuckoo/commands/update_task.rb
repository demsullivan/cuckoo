require 'skywalker/command'

module Cuckoo
  module Commands
    class UpdateTaskCommand < Skywalker::Command
      def execute!
        puts "update task called '#{context.task}'"
      end

      private def required_args
        %w(context on_success on_failure)
      end
    end
  end
end
