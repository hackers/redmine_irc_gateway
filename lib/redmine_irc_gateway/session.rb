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

      @user = User.start_session(:nick => @nick, :key => @pass, :profile => @user)

      auto_join_to_channels

      crawl_recent_issues(get_crawl_interval) do |issue|
        privmsg issue
      end

    end

    # Receive message and response
    def on_privmsg m
      message = Message.new(:channel => m.params[0], :content => m.params[1])

      talk message do |response|
        notice response
      end
    end

    # Disallow join to a channel
    def on_join message
      post(server_name, ERR_INVITEONLYCHAN, @nick, 'Invite only')
    end

    # To clear the issue database on disconnect
    def on_disconnected
      db_path = "#{DB_PATH}.#{@user.nick}.#{@user.profile}"
      db = SDBM.open db_path

      db.clear
      @log.info "Clear: #{db_path}"
      db.close
      @log.info 'Database cleared'
    end

    private

    def get_crawl_interval
      config = RedmineIRCGateway::Config.load
      interval = config.get(@user.profile)['interval'] || config.default['interval'] || 300
    end

    def auto_join_to_channels
      @timeline = Channel.timeline
      join @timeline

      @user.channels.values.each do |channel|
        join channel
      end
    rescue => e
      @log.error e
    end

    def join channel
      post(@prefix, JOIN, channel.name)
      post(nil, RPL_NAMREPLY,   @prefix.nick, '=', channel.name, channel.users.join(' '))
      post(nil, RPL_ENDOFNAMES, @prefix.nick, channel.name, 'End of NAMES list')
      post(nil, TOPIC, channel.name, channel.topic) if channel.topic
    end

    def crawl_recent_issues(interval = 300)
      Thread.new do
        loop do
          @user.connect_redmine
          Command.recent.each do |issue|
            yield [issue.speaker, @timeline.name, issue.content]

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
      @user.connect_redmine
      Command.exec(message.command, message.id).each do |issue|
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
