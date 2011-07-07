module RedmineIrcGateway
  class Server < Net::IRC::Server::Session
    def server_name
      self.class.to_s
    end

    def server_version
      '0.0.0'
    end

    def owner_channel
      "##{server_name}"
    end

    def owner_user
      server_name
    end

    def initialize(*args)
      super
      @channels = {}
      @config   = Pathname.new(ENV["HOME"]) + ".rig"
      @pit = Pit.get(server_name)
    end

    # login to server
    def on_user(m)
      super
      @real, *@opts = @real.split(/\s+/)
      @opts ||= []

      init_user(m)
    end

    # logout from server
    def on_disconnected
      p @channels
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
        @channels[channel] = { :topic => "" } unless @channels.key?(channel)
        post @prefix, JOIN, channel
        ## Join時にユーザ一覧を返す場合はここに追加する。
        post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, "@#{@prefix.nick} #{names*' '}".strip
        post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
      end
    end

    def on_privmsg(m)
      channel, message, = m.params

      if @pit[:redmine_token].nil?
        @pit[:redmine_token] = message
        Pit.set(server_name, :data => @pit)
        m.params[0] = owner_channel
        m.params[1] = "Token Stored."
        on_notice m
      elsif @channels.key?(channel)
        post @prefix.nick, PRIVMSG, channel, message
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

    def store_config(message = nil)
      if @pit.empty?
        "Please, input Redmine Url"
      elsif @pit[:redmine_url].nil?
        save_config(:redmine_url, message)
        "Please, input Redmine User"
      elsif @pit[:redmine_user].nil?
        save_config(:redmine_user, message)
        "Please, input Redmine Password"
      elsif @pit[:redmine_password].nil?
        save_config(:redmine_password, message)
        "Stored Config. Thanks."
      else
        nil
      end
    end

    def save_config(key, value)
      @pit[key] = value
      Pit.set(server_name, :data => @pit)
    end
  end
end
