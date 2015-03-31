module Cuckoo
  module Taggers
    class Tag < PrefixedWord
      PREFIX  = '#'
      PATTERN = '[[:alpha:]]+'
      TAG     = :tags
    end
  end
end
