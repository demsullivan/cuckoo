require 'chronic'
require 'chronic_duration'
require 'cuckoo/context'

module Cuckoo
  class Parser

    def initialize
    end

    def complete(line)
      [line]
    end

    def process(line)
      p line
      {:line => line}
    end

    
  end
end
