module Cuckoo
  class TaskId < PrefixedWord
    PREFIX  = '#'
    PATTERN = '\d+'
    TAG     = :taskid
  end
end
