module RedmineIRCGateway
  class Message

    class << self
      def parse m
        self.new m
      end
    end

    attr_accessor :command, :channel, :content

    def initialize m
      @command = m.command
      @channel, @content = m.params
    end

    def to_s
      @content
    end

    def to_sym
      @content.to_sym
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
