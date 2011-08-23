module RedmineIRCGateway
  class Message < Net::IRC::Message

    attr_accessor :channel, :content

    def initialize(*args)
      super
      @channel, @content = @params
    end

    def order
      @content.downcase.to_sym
    end

  end
end
