module RedmineIRCGateway
  class Channel

    attr_accessor :topic, :users, :observer

    def initialize(channel_name, users = [])
      @channel_name = channel_name
      @users ||= {}

      users.each do |user|
        @users[user] = User.new(user)
      end

      @topic = ""
    end

  end
end
