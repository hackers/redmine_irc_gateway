module RedmineIRCGateway
  class Console < Channel

    def initialize(channel, prefix, users = [])
      super
    end

    def talk(message)
      command = message.strip.split(/\s/)
      Setting.send(command.shift.downcase.to_sym, *command)
    rescue NoMethodError => e
      puts e
      [NOTICE, "COMMAND NOT FOUND"]
    rescue => e
      puts e
      [NOTICE, "COMMAND ERROR"]
    end

  end
end
