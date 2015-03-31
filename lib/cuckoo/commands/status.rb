require 'skywalker/command'

module Cuckoo
  module Commands
    class StatusCommand < Skywalker::Command
      def execute!
        puts "status is nil"
      end

      private def required_args
        %w(context on_success on_failure)
      end
    end
  end
end
