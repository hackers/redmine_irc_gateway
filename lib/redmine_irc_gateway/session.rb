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

      crawl_recent_issues
    end

    # Receive message and response
    def on_privmsg message
      if message.channel == @console.name
        @console.talk(message).each do |mess|
          send(:post, *[@console.operator, NOTICE, channel, mess])
        end
      else
        talk(message) { |response| send(:post, *response) }
      end
    end

    # Set password to Redmine API
    def on_pass message
      super
      Redmine::API.key = @pass
    end

    def on_join message
      post(server_name, ERR_INVITEONLYCHAN, @nick, 'Invite only')
    end

    private

    def auto_join_to_channels
      @console = Console.new
      @main    = Channel.main

      ([@console, @main] + Channel.all).each { |channel| join channel }
    rescue => e
      @log.error e
    end

    def join(channel)
      post(@prefix, JOIN, channel.name)
      post(nil, RPL_NAMREPLY,   @prefix.nick, '=', channel.name, channel.users.join(' '))
      post(nil, RPL_ENDOFNAMES, @prefix.nick, channel.name, 'End of NAMES list')
    end

    def crawl_recent_issues
      Thread.new do
        loop do
          Redmine.all.each do |issue|
            send(:post, *[issue.author, PRIVMSG, @main.name, "#{issue.project_name} #{issue.content}"])

            if channel = Channel.find(issue.project_id)
              send(:post, *[issue.author, PRIVMSG, channel.name, issue.content])
            end
          end
          sleep 300
        end
      end
    rescue => e
      @log.error e
    end

    def talk(message)
      Redmine.send(message.order).each do |issue|
        yield [issue.author, NOTICE, message.channel, issue.content]
      end
    rescue NoMethodError => e
      @log.error e
      yield [nil, NOTICE, message.channel, 'Command Not Found']
    rescue => e
      @log.error e
    end

  end
end
