module RedmineIRCGateway
  class Console < Channel

    attr_reader :operator

    def initialize
      @name = '#console'
      @operator = '@Redmine'
      @users = [@operator]
    end

    def talk(message)
      command = message.content.split(/\s/)
      Setting.send(command.shift.downcase.to_sym, *command) do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield [@operator, "Command Not Found"]
    rescue => e
      puts e
      yield [@operator, "Command Error"]
    end

  end
end
