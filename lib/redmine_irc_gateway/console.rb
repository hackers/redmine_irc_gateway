module RedmineIRCGateway
  class Console < Channel

    def initialize(channel, prefix, users = [])
      super
    end

    def talk(message)
      message.strip!
      result = []
      result
    end

  end
end
