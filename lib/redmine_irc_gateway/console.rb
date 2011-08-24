module RedmineIRCGateway
  class Console < Channel

    def talk(message)
      command = message.content.split(/\s/)
      Setting.send(command.shift.downcase.to_sym, *command) do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield "Command Not Found"
    rescue => e
      puts e
      yield "Command Error"
    end

  end
end
