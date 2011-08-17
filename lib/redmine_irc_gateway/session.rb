module RedmineIRCGateway
  class Session < Net::IRC::Server::Session

    attr_accessor :config, :channels, :prefix

    def server_name
      Module.nesting.last.to_s
    end

    def owner_user
      "@Redmine"
    end

    def server_version
      RedmineIRCGateway::VERSION
    end

    def owner_channel
      "##{server_name}"
    end

    def config_channel
      "#Console"
    end

    def initialize(*args)
      super
      @channels = {}
      @config = Pit.get(server_name)
      @channel_thread = []
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
    def on_join(m, channel = nil)
      channels = channel || m.params.first.split(/,/)
      channels.each do |channel|
        if !@channels.key?(channel)
          @channels[channel] = Channel.new(channel, self, @prefix, [owner_user])
          @channel_thread << Thread.new do
            @channels[channel].crowl
          end
        end
      end
    end

    def on_privmsg(m)
      channel, message, = m.params

      if @channels.key?(channel)
        @channels[channel].talk message
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
      if !@channels.key?(config_channel)
        @channels[config_channel] = Console.new(config_channel, self, @prefix, [owner_user])
      end
    end

  end
end
