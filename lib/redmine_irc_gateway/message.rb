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

class Net::IRC::Message
  #  Monkey patch Net::IRC::Message.parse
  #  call RedmineIRCGateway::Message.new instead of Net::IRC::Message.new
  def self.parse(str)
    _, prefix, command, *rest = *PATTERN::MESSAGE_PATTERN.match(str)
    raise InvalidMessage, "Invalid message: #{str.dump}" unless _

    case
    when rest[0] && !rest[0].empty?
      middle, trailer, = *rest
    when rest[2] && !rest[2].empty?
      middle, trailer, = *rest[2, 2]
    when rest[1]
      params  = []
      trailer = rest[1]
    when rest[3]
      params  = []
      trailer = rest[3]
    else
      params  = []
    end

    params ||= middle.split(/ /)[1..-1]
    params << trailer if trailer

    RedmineIRCGateway::Message.new(prefix, command, params)
  end
end
