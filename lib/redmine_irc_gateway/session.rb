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
        VERSION
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
          _ins.observer.kill if _ins.observer
        end
      rescue
      end

      # join to channel
      def on_join(m, channel = nil)
        channels = channel || m.params.first.split(/,/)

        channels.each do |channel|
          if !@channels.key?(channel)
            @channels[channel] = Channel.new(channel, [owner_user])
            join channel, [owner_user]
          end
        end

        Thread.new do
          loop do
            Order.all.each do |issue|
              @channels.each do |channel_name, channel|
                send(:post, *[issue[0], JOIN, channel.name])
                send(:post, *[issue[0], PRIVMSG, channel.name, issue[1]])
              end
            end
            sleep 300
          end
        end
      end

      def on_privmsg message
        channel = message.channel

        if channel == @console.name
          @console.talk(message).each do |mess|
            send(:post, *[owner_user, NOTICE, channel, mess])
          end
        elsif @channels.key?(channel)
          @channels[channel].talk(message) do |m|
            send(:post, *[m[0], NOTICE, channel, m[1]])
          end
        end
      end

      # Set password to Redmine API
      def on_pass m
        super
        #@log.debug 'Type your password in a IRC server password, and you try to connect again.' if @pass.nil?
        Redmine::API.key = @pass
      end

      private

      def start_observer
        unless @console
          @console = Console.new(config_channel, [owner_user])
          join config_channel, [owner_user]
          on_join(nil, [owner_channel])
        end
      end

      def join(channel, users = [])
        post @prefix, JOIN, channel
        post nil, RPL_NAMREPLY,   @prefix.nick, "=", channel, users.join(" ")
        post nil, RPL_ENDOFNAMES, @prefix.nick, channel, "End of NAMES list"
      end

    end
  end
