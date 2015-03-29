module Cuckoo
  class Token

    attr_reader :tags
    attr_reader :word
    
    def initialize(word)
      @word = word
      @tags = []
    end

    def tag(name)
      @tags << name
    end

    def untag
      @tags = []
    end

    def tagged?
      @tags.length > 0
    end
  end
end
