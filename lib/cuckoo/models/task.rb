module Cuckoo
  module Models
    class Task < ActiveRecord::Base
      belongs_to :project
    end
  end
end
