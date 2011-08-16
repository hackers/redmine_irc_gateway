module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants 

    def initialize(channel, session, prefix, users = [])
      @session = session
      @prefix = prefix
      @name = channel
      on_join(channel, users)
    end

    def post(prefix, command, *params)
      @session.post prefix, command, *params
    end

    private
    def on_join(channel, users)
      post @prefix, JOIN, channel
      post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, users.join(" ")
      post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
    end

    def on_privatemsg
      @session.on_privmsg
    end

  end
end
