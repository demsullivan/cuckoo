module Cuckoo
  module Models
    class Project < ActiveRecord::Base
      has_many :tasks
    end
  end
end
