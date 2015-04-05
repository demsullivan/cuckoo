module Cuckoo
  module Commands
    class CreateCommand

      attr_accessor :update_context

      def call(args)
        puts args[:cmd_context].cmd
      end
    end
  end
end
