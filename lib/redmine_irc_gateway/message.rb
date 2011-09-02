module RedmineIRCGateway
  class Message

    attr_accessor :channel, :content

    def initialize params
      @channel, @content = params
    end

    def instruction
      @content.downcase.to_sym
    end

  end
end
