module RedmineIRCGateway
  class Channel < Hash

    attr_reader :name, :users, :project_id, :topic, :channels

    class << self
      # Return main channel instance
      def main
        self.new({ :name => :Redmine, :project_id => 0 })
      end

      # Return my all channel instances
      def all
        self.new.list
      end
    end

    def initialize(params = nil)
      if params
        @name       = "##{params[:name]}"
        @users      = params[:users] || []
        @project_id = params[:project_id]
        @topic      = params[:topic] || ''
      end
    end

    # Return all channel names
    def names
      config = Config.load.get(User.session.profile)
      config['channels'] ||= []
    end

    # Return all channel instances
    def list
      names.each { |name, id| add(get(name, id.to_s)) }
      self
    end

    # Add channel instance to stack
    def add channel
      self[channel.project_id] = channel
    end

    # Find channel instance at stack
    def find project_id
      self[project_id]
    end

    # Return find or create channel instance
    def get channel_name, project_id
      channel = find project_id
      unless channel
        project = Redmine::Project.find(project_id)
        channel = Channel.new({
          :name       => channel_name,
          :project_id => project_id,
          :users      => project.members,
          :topic      => project.description
        })
      end
      channel
    end

  end
end
