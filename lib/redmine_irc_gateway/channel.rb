module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants 

    def initialize(channel, session, prefix, users = [])
      @session = session
      @prefix = prefix
      @name = channel
      @owner_user = users.first
      on_join(channel, users)
    end

    def post(prefix, command, *params)
      @session.post prefix, command, *params
    end

    def talk(message)
      if message == 'list'
        Redmine::Issue.find(:all).each { |i| post @owner_user, PRIVMSG, @name, "4[ #{i.id} ] #{i.subject}" }
      else
        begin
          issue_subject = Redmine::Issue.find(message).subject
        rescue
          issue_subject = 'Not found'
        end
        post owner_user, PRIVMSG, @name, issue_subject
      end
    end

    def crowl
      Redmine::Issue.watched.each do |issue|
        privmsg "#[#{issue.id}] #{issue.subject}"
      end
    end

    def notice(message)
      post @owner_user, NOTICE, @name, message
    end

    def privmsg(message)
      post @owner_user, PRIVMSG, @name, message
    end

    private
    def on_join(channel, users = [])
      post @prefix, JOIN, channel
      post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, users.join(" ")
      post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
    end
  end
end
