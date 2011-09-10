module RedmineIRCGateway
  class Channel

    attr_reader :name, :users, :project_id, :topic

    @@channels = {}

    def initialize(name, project_id, users = [], topic = '')
      @name       = "##{name}"
      @users      = users || []
      @project_id = project_id
      @topic      = topic
    end

    class << self

      # Return main channel instance
      def main
        self.new :Redmine, 0
      end

      # Return all channel names
      def names
        channel = Config.load
        channel.channels ||= []
      end

      # Return all channel instances
      def all
        self.names.each { |name, id| self.add(self.get(name, id.to_s)) }
        @@channels.values
      end

      # Add channel instance to stack
      def add channel
        @@channels[channel.project_id] = channel
      end

      # Find channel instance at stack
      def find project_id
        @@channels[project_id]
      end

      # Return find or create channel instance
      def get channel_name, project_id
        channel = self.find project_id
        unless channel
          project = Redmine::Project.find(project_id)
          channel = self.new(channel_name, project_id, project.members, project.description)
        end
        channel
      end

    end
  end
end
