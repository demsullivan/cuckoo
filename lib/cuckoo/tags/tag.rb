module Cuckoo
  class Tag < PrefixedWord
    PREFIX  = '#'
    PATTERN = '[[:alpha:]]+'
    TAG     = :tags
  end
end
