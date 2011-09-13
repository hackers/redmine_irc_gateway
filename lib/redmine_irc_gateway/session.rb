module RedmineIRCGateway
  class Session < Net::IRC::Server::Session

    def server_name
      Module.nesting.last.to_s
    end

    def server_version
      VERSION
    end

    # Login to server
    def on_user message
      if @pass.nil?
        post(server_name, ERR_NEEDMOREPARAMS, @nick,
             'Type your password in a IRC server password, and you try to connect again.')
        return finish
      end

      super

      @user = User.start_session({ :nick => @nick, :key => @pass, :profile => @user })

      auto_join_to_channels

      crawl_recent_issues 60 do |issue|
        privmsg issue
      end

    end

    # Receive message and response
    def on_privmsg m
      message = Message.new({ :channel => m.params[0], :content => m.params[1] })

      case message.channel
      when @console.name
        @console.talk(message).each do |response|
          notice [@console.operator, message.channel, response]
        end
      else
        talk message do |response|
          notice response
        end
      end
    end

    # Disallow join to a channel
    def on_join message
      post(server_name, ERR_INVITEONLYCHAN, @nick, 'Invite only')
    end

    # To clear the issue database on disconnect
    def on_disconnected
      db = SDBM.open DB_PATH
      db.clear
      db.close
      @log.info 'Database cleared'
    end

    private

    def auto_join_to_channels
      @console = Console.new
      @main    = Channel.main

      ([@console, @main] + @user.channels.values).each { |channel| join channel }
    rescue => e
      @log.error e
    end

    def join channel
      post(@prefix, JOIN, channel.name)
      post(nil, RPL_NAMREPLY,   @prefix.nick, '=', channel.name, channel.users.join(' '))
      post(nil, RPL_ENDOFNAMES, @prefix.nick, channel.name, 'End of NAMES list')
      post(nil, TOPIC, channel.name, channel.topic) if channel.topic
    end

    def crawl_recent_issues interval = 300
      Thread.new do
        loop do
          Command.recent.each do |issue|
            yield [issue.speaker, @main.name, issue.content]

            if channel = @user.channels.find(issue.project_id)
              yield [issue.speaker, channel.name, issue.content]
            end
          end
          sleep interval
        end
      end
    rescue => e
      @log.error e
    end

    def talk message
      Command.exec(message.instruction).each do |issue|
        yield [issue.speaker || @prefix.nick, message.channel, issue.content]
      end
    end

    def privmsg message
      send(:post, message.shift, PRIVMSG, *message)
    end

    def notice message
      send(:post, message.shift, NOTICE, *message)
    end

  end
end
