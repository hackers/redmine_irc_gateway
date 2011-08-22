module RedmineIRCGateway
  class Message < Net::IRC::Message

    attr_accessor :channel, :content

    def initialize(*args)
      super
      @channel, @content = @params
    end

    # TODO
    def privmsg m
      @command = PRIVMSG
    end


    # TODO
    def notice m
      @command = NOTICE
    end

    # TODO
    def topic m
      @command = TOPIC
    end

  end
end
