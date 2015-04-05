require 'trello'

TrelloAPI = ::Trello

module Cuckoo
  module Trello
    class Plugin < Cuckoo::ExternalSystemPlugin

      def initialize(config)
        @config = config

        binding.pry
        TrelloAPI.configure do |config|
          config.developer_public_key = @config.developer_public_key
          config.member_token         = @config.member_token
        end
      end

      ################################################################################
      private
      ################################################################################
      def all_trello_projects
        ::Trello::Board.all
      end

      def sync_tasks_from(projects)
        projects.each do |project|
          trello_project = ::Trello::Board.find(project.external_project_id)

          trello_project.cards.each do |card|
            task = project.tasks.where(:external_task_id => card.id)
            Task.create(:project => project, :external_task_id => card.id, :name => card.name) unless task.any?
          end
        end
      end
    end

    class ConfigFactory < Cuckoo::PluginConfigFactory
      attr_accessor :developer_public_key
      attr_accessor :member_token
    end
  end
end
