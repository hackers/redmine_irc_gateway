module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants

    def initialize(channel, prefix, users = [])
      @prefix = prefix
      @name = channel
      @owner_user = users.first
    end

    def talk(message)
      Command.send(message.content.to_sym).each do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield [@owner_user, "Command Not Found"]
    rescue => e
      yield [@owner_user, "Command Error"]
    end

    def crowl
      messages = []
      Redmine::Issue.watched.each do |issue|
        messages << [PRIVMSG, "##{issue.id} [#{issue.project.name}] - #{issue.subject}"]
      end

      Remine::Issue.assigned_me do |issue|
        messages << [PRIVMSG, "##{issue.id} [#{issue.project.name}] - #{issue.subject}"]
      end
      p messages
      messages
    end

  end
end
