module RedmineIRCGateway
  class Message

    attr_accessor :channel, :content, :speaker, :project_id

    def initialize args
      @channel    = args[:channel]
      @project_id = args[:project_id]
      @speaker    = args[:speaker]
      @content    = args[:content]
    end

    def instruction
      @content.downcase.to_sym
    end

  end
end
