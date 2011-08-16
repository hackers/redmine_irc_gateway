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

    def config_channel
      "#Console"
    end

    def initialize(*args)
      super
      @channels = {}
      @pit = Pit.get(server_name)
      @pit[:server_name] ||= server_name
    end

    def post(*param)
      super
    end

    # login to server
    def on_user(m)
      super
      @real, *@opts = @real.split(/\s+/)
      @opts ||= []

      start_observer
    end

    # logout from server
    def on_disconnected
      @channels.each do |chan, _ins|
        begin
          _ins.observer.kill if _ins.observer
        rescue
        end
      end
    end

    # join to channel
    def on_join(m)
      channels = m.params.first.split(/,/)
      channels.each do |channel|
        if !@channels.key?(channel)
          @channels[channel] = Channel.new(channel, self, @prefix)
        end
      end
    end

    def on_privmsg(m)
      channel, message, = m.params

      case channel
      when config_channel
        send_message = @authority.prive channel, message
        if !send_message.nil?
          m.modify!(config_channel, send_message)
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
      end
    end

    private
    def start_observer()
      @channels[config_channel] = Console.new(config_channel, self, @prefix, ["@#{owner_user}"])
    end

  end
end
