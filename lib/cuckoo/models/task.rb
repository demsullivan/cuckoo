module Cuckoo
  module Models
    class Task < ActiveRecord::Base
      belongs_to :project
      has_many :notes, as: :notable

      after_save :populate_external_task_id, unless: :has_external_task_id?


      def populate_external_task_id
        external_task_id = id.to_s
      end

      def has_external_task_id?
        not external_task_id.nil?
      end
    end
  end
end
