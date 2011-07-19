module RedmineIRCGateway
  class Session < Net::IRC::Server::Session

    def server_name
      Module.nesting.last.to_s
    end

    def owner_user
      :Redmine
    end

    def server_version
      RedmineIRCGateway::VERSION
    end

    def owner_channel
      @pit[:owner_channel] ||= "##{server_name}"
    end

    def initialize(*args)
      super
      @channels = {}
      @pit = Pit.get(server_name)
      @pit[:server_name] ||= server_name
    end

    # login to server
    def on_user(m)
      super
      @real, *@opts = @real.split(/\s+/)
      @opts ||= []

      start_observer m
    end

    # logout from server
    def on_disconnected
      @channels.each do |chan, info|
        begin
          info[:observer].kill if info[:observer]
        rescue
        end
      end
    end

    # join to channel
    def on_join(m, names = [])
      channels = m.params.first.split(/,/)
      channels.each do |channel|
        if !@channels.key?(channel)
          @channels[channel] = { :topic => "" }
          post @prefix, JOIN, channel
          ## Join時にユーザ一覧を返す場合はここに追加する。
          post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, "@#{@prefix.nick} #{names*' '}".strip
          post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
        end
      end
    end

    def on_privmsg(m)
      channel, message, = m.params

      case channel
      when owner_channel
        send_message = @authority.prive channel, message
        if !send_message.nil?
          m.modify!(owner_channel, send_message)
          on_notice m
        end
      else
        if @channels.key?(channel)
          if message == 'list'
            Redmine::Issue.find(:all).each { |i| post owner_user, PRIVMSG, channel, "4[ #{i.id} ] #{i.subject}" }
          else
            begin
              issue_subject = Redmine::Issue.find(message).subject
            rescue
              issue_subject = 'Not found'
            end
            post owner_user, PRIVMSG, channel, issue_subject
          end
        end
      end
    end

    def on_notice(m)
      channel, message, = m.params
      if @channels.key?(channel)
        post @prefix.nick, NOTICE, channel, message
      end
    end

    def on_topic(m)
      channel, topic, = m.params
      if @channels.key?(channel)
        post @prefix, TOPIC, channel, topic
        @channels[channel][:topic] = topic
      end
    end

    private
    def start_observer(m)
      m.params[0] = owner_channel
      users = ["@#{owner_user}"]
      on_join(m, users)

      @authority = Authority.new(@pit)
      send_message = @authority.prive owner_channel

      if !send_message.nil?
        m.modify!(owner_channel, send_message)
        on_notice m
      end
    end

  end
end
