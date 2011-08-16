module RedmineIRCGateway
  class Console < Channel

    def initialize(channel, session, prefix, users = [])
      super

      @command = {
        :user => 'Redmine Account User',
        :password => 'Redmine User Password',
        :url => 'Redmine URL'
      }

      notice "COMMAND LIST"
      notice "    set key value"
      notice "    delete  key"
      notice "KEYS LIST"
      @command.each{ |key,val|
        notice "    #{key}  - #{val}"
      }
    end

    def notice(message)
      post @owner_user, NOTICE, @name, message
    end

    def talk(message)
      message.strip!
      if message =~ /^set\s(.+?)\s(.+)/
        result = set_parameter $1, $2
      elsif message =~ /^delete\s(.+?)/
        result = get_parameter $1
      else
        result = "BAD COMMAND!!"
      end
      
      notice result
    end

    private
    def set_parameter(key, val)
      if @command.key?(key.to_sym)
        @session.config[key] = val
        Pit.set(@session.server_name, :data => @session.config)
        "Success set #{key}"
      else
        "Failure set #{key}"
      end
    end

    def get_parameter(key)
      if @command.key?(key.to_sym)
        @session.config.delete(key)
        Pit.set(@session.server_name, :data => @session.config)
        "Success delete #{key}"
      else
        "Failure delete #{key}"
      end
    end

  end
end
