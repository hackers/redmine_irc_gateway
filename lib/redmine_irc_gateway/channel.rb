module RedmineIRCGateway
  class Channel

    attr_reader :name, :users, :project_id, :topic

    @@channels = {}
    @@names = [:rig]

    def initialize(name, project_id, users = [], topic = nil)
      @name       = "##{name}"
      @users      = users
      @project_id = project_id
      @topic      = topic
    end

    class << self
      # Return all channel names
      def names
        @@names
      end

      # Return all channel instances
      def all
        self.names.each { |name| self.add(self.get(name)) }
        @@channels.values
      end

      # Add channel instance to stack
      def add channel
        @@channels[channel.name] = channel
      end

      # Find channel instance at stack
      def find channel_name
        @@channels[channel_name]
      end

      # Return find or create channel instance
      def get channel_name
        channel = self.find channel_name
        unless channel
          channel = self.new(channel_name, 'dummy_projet_id', Redmine.online_users('dummy project_id'))
        end
        channel
      end

    end
  end
end
