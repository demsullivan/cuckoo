require 'skywalker'

module Cuckoo
  module Commands
    class StopCommand < Skywalker::Command
      def execute!
        puts "stop timer"
      end

      private def required_args
        %w(context on_success on_failure)
      end
    end
  end
end
