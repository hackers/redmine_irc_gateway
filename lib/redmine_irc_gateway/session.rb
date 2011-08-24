module RedmineIRCGateway
  class Session < Net::IRC::Server::Session

    def server_name
      Module.nesting.last.to_s
    end

    def server_version
      VERSION
    end

    # login to server
    def on_user message
      if @pass.nil?
        post(server_name, ERR_NEEDMOREPARAMS, @nick, 'Type your password in a IRC server password, and you try to connect again.')
        return finish
      end

      super

      auto_join_to_channels
      run_timeline_thread
    end

    def on_privmsg message
      channel = message.channel
      channel_key = channel.gsub('#', '').to_sym

      if channel == @console.name
        @console.talk(message).each do |mess|
          send(:post, *[@console.operator, NOTICE, channel, mess])
        end
      elsif @channels.key?(channel_key)
        @channels[channel_key].talk(message) do |m|
          send(:post, *[m[0], NOTICE, channel, m[1]])
        end
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
      @channels = {}

      @console = Console.new
      join @console

      channel_names = [:rig]
      channel_names.each { |name| create_and_join_to_channel name  }
    rescue => e
      @log.error e
    end

    def create_and_join_to_channel(channel_name)
      unless @channels.key? channel_name
        channel = Channel.new(channel_name, 'dummy_projet_id', Order.online_users('dummy project_id'))
        @channels[channel_name] = channel
      end

      join @channels[channel_name]
    end

    def join(channel)
      post(@prefix, JOIN, channel.name)
      post(nil, RPL_NAMREPLY,   @prefix.nick, "=", channel.name, channel.users.join(' '))
      post(nil, RPL_ENDOFNAMES, @prefix.nick, channel.name, 'End of NAMES list')
    end

    def run_timeline_thread
      Thread.new do
        loop do
          Order.all.each do |issue|
            @channels.each do |channel_name, channel|
              send(:post, *[issue[0], PRIVMSG, channel.name, issue[1]])
            end
          end
          sleep 300
        end
      end
    rescue => e
      @log.error e
    end

  end
end
