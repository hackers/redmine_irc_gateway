module RedmineIRCGateway
  class Channel

    attr_reader :name, :users, :project_id, :topic

    @@channels = {}
    @@names = []

    def initialize(name, project_id, users = [], topic = nil)
      @name       = "##{name}"
      @users      = users || []
      @project_id = project_id
      @topic      = topic
    end

    class << self

      # main channel
      def main
        self.new :Redmine, '00'
      end

      # Return all channel names
      def names
        @@names + Redmine::User.current.projects.collect { |p| p.id }
      end

      # Return all channel instances
      def all
        self.names.each { |name| self.add(self.get(name)) }
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
      def get project_id
        channel = self.find project_id
        unless channel
          project = Redmine::Project.find project_id
          channel = self.new(project.identifier, project_id, Redmine.online_users(project_id))
        end
        channel
      end

      def load
         channel = Config.load("channel")
         channel.each do |cn, pi|
           self.new cn, pi
	 end
      end

    end
  end
end
