module Cuckoo
  module Models
    class Tag < ActiveRecord::Base
      has_and_belongs_to_many :taggables, polymorphic: true
    end
  end
end
