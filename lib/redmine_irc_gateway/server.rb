#!/usr/bin/env ruby

module RedmineIRCGateway
  class Server < Net::IRC::Server::Session

    def server_name
      Module.nesting.last.to_s
    end

    def owner_user
      :Redmine
    end

    def server_version
      '0.0.0'
    end

    def owner_channel
      "##{server_name}"
    end

    def initialize(*args)
      super
      @channels = {}
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
        send_message = store_config(message)
        if !send_message.nil?
          m.modify!(owner_channel, send_message)
          on_notice m
        end
      else
        if @channels.key?(channel)
          if message == 'list'
            Issue.find(:all).each { |i| post owner_user, PRIVMSG, channel, "4[ #{i.id} ] #{i.subject} by 3#{i.author.name}" }
          else
            begin
              issue_subject = Issue.find(message).subject
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
    def init_user(m)
      m.params[0] = owner_channel
      users = ["@#{owner_user}"]
      on_join(m, users)

      send_message = store_config
      if !send_message.nil?
        m.modify!(owner_channel, send_message)
        on_notice m
      end
    end

    def store_config(message = nil)
      if @pit.empty? && message.nil?
        "Please, input Redmine URL"
      elsif @pit[:url].nil?
        save_config(:url, message)
        "Please, input Redmine User"
      elsif @pit[:user].nil?
        save_config(:user, message)
        "Please, input Redmine Password"
      elsif @pit[:password].nil?
        save_config(:password, message)
        "Stored Config. MAHALO."
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
