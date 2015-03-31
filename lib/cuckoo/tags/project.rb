module Cuckoo
  module Taggers
    class Project < PrefixedWord
      PREFIX  = '@'
      PATTERN = '\w+'
      TAG     = :project
    end
  end
end
