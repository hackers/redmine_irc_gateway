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

      auto_join_to_channels

      crawl_recent_issues 30 do |issue|
        privmsg issue
      end
    end

    # Receive message and response
    def on_privmsg message
      if message.channel == @console.name
        @console.talk(message).each do |mess|
          notice([@console.operator, channel, mess])
        end
        return
      end

      talk message do |response|
        notice response
      end
    end

    # Set password to Redmine API
    def on_pass message
      super
      Redmine::API.key = @pass
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

      ([@console, @main] + Channel.all).each { |channel| join channel }
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
          Redmine.all.each do |issue|
            yield [issue.user, @main.name, "#{issue.project_name} #{issue.content}"]

            if channel = Channel.find(issue.project_id)
              yield [issue.user, channel.name, issue.content]
            end
          end
          sleep interval
        end
      end
    rescue => e
      @log.error e
    end

    def talk message
      Redmine.send(message.order).each do |issue|
        yield [issue.user, message.channel, "#{issue.project_name} #{issue.content}"]
      end
    rescue NoMethodError => e
      @log.error e
      yield [@console.operator, message.channel, 'Command not found']
    rescue => e
      @log.error e
    end

    def privmsg message
      send(:post, message.shift, PRIVMSG, *message)
    end

    def notice message
      send(:post, message.shift, NOTICE, *message)
    end

  end
end
