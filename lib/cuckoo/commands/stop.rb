module Cuckoo
  module Commands
    class StopCommand

      attr_accessor :update_context
      
      def call(args)
        @context = args[:context]

        unless @context.timer.nil?
          @context.timer.pause

          @context.time_entry.finished_at = DateTime.now
          @context.time_entry.save!
        end
      end


    end
  end
end
