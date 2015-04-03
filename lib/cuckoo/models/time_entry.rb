module Cuckoo
  module Models
    class TimeEntry < ActiveRecord::Base
      
      # ASSOCIATIONS
      belongs_to :task
      has_many :notes, as: :notable

      scope :any_tags,     -> (tags){ where('tags && ARRAY[?]', tags)}
      scope :all_tags,     -> (tags){ where('tags @> ARRAY[?]', tags)}
      scope :without_tags, -> (tags){ where('NOT tags @> ARRAY[?]', tags)}
      
    end
  end
end
