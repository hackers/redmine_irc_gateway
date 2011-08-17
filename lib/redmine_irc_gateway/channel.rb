module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants 

    def initialize(channel, prefix, users = [])
      @prefix = prefix
      @name = channel
      @owner_user = users.first
    end

    def talk(message)
      messages = []
      if message == 'list'
        Redmine::Issue.find(:all).each { |i| post @owner_user, PRIVMSG, @name, "4[ #{i.id} ] #{i.subject}" }
      else
        begin
          messages << [PRIVMSG, issue_subject = Redmine::Issue.find(message).subject]
        rescue
          issue_subject = 'Not found'
        end
      end
      messages
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
