module Cuckoo
  class Completer
    def call(line)
      context = Context.new
      command = CommandInput(line, context)
      line.split
    end
  end  
end
