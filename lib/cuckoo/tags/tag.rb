module Cuckoo
  class Tag < PrefixedWord
    PREFIX  = '#'
    PATTERN = '[a-zA-Z]+'
    TAG     = :tags
  end
end
