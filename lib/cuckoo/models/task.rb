module Cuckoo
  module Models
    class Task < ActiveRecord::Base
      belongs_to :project
      has_many :notes, as: :notable

      def has_external_task_id?
        not external_task_id.nil?
      end

      def time_spent
      end

      def unbilled_time_spent
      end

      
    end
  end
end
