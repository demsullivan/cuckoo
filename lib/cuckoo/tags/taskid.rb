module Cuckoo
  module Taggers
    class TaskId < PrefixedWord
      PREFIX  = '#'
      PATTERN = '\d+'
      TAG     = :taskid
    end
  end
end
