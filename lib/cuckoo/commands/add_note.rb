module Cuckoo
  module Commands
    class AddNoteCommand
      include Cuckoo::Models
      
      def call(args)
        @context = args[:context]

        content = @cmd_context.cmd.split(' ')[1..-1].join(' ')
        
        if @context.has_active_task?
          note = Note.new(:notable => @context.time_entry, :content => content)
          note.save!
          puts "Created note."
        end
      end
    end
  end
end
