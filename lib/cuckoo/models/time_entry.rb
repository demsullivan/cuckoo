module Cuckoo
  module Models
    class TimeEntry < ActiveRecord::Base
      
      # ASSOCIATIONS
      belongs_to :task
      has_many :notes, as: :notable

      scope :any_tags,     -> (tags){ where('tags && ARRAY[?]', tags)}
      scope :all_tags,     -> (tags){ where('tags @> ARRAY[?]', tags)}
      scope :without_tags, -> (tags){ where('NOT tags @> ARRAY[?]', tags)}

      before_save :populate_duration, :if => :is_complete?

      def populate_duration
        duration = (finished_at.to_time - started_at.to_time).to_i
      end
      
      def is_complete?
        not started_at.nil? and not finished_at.nil?
      end
    end
  end
end
