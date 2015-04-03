require 'skywalker/command'

module Cuckoo
  module Commands
    class CreateCommand < Skywalker::Command
      def execute!
        puts cmd_context.cmd
      end

      private def required_args
        %w(context cmd_context on_success on_failure)
      end
    end
  end
end
