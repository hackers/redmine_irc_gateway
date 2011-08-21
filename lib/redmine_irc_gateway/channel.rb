module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants 

    def initialize(channel, prefix, users = [])
      @prefix = prefix
      @name = channel
      @owner_user = users.first
    end

    def talk(message)
      Command.send(message.to_sym)
    rescue NoMethodError => e
      puts e
      ["Command Not Found"]
    rescue => e
      ["Command Error"]
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
