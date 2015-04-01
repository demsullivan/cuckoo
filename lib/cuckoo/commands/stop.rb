require 'skywalker/command'

module Cuckoo
  module Commands
    class StopCommand < Skywalker::Command
      attr_accessor :update_context
      
      def execute!
        context.timer.stop unless context.timer.nil?
      end

      private def required_args
        %w(context on_success on_failure)
      end
    end
  end
end
