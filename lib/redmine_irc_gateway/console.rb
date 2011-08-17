module RedmineIRCGateway
  class Console < Channel

    def initialize(channel, session, prefix, users = [])
      super

      @command = {
        :url => 'Redmine URL Address',
        :key => 'Redmine API Key'
      }

      notice "COMMAND LIST"
      notice "    set key value"
      notice "    delete  key"
      notice "    show"
      notice "KEYS LIST"
      @command.each{ |key,val|
        notice "    #{key}  - #{val}"
      }
      is_authority 
    end

    def talk(message)
      message.strip!
      if message =~ /^set\s(.+?)\s(.+)/
        result = [set_parameter $1, $2]
      elsif message =~ /^delete\s(.+?)/
        result = [get_parameter $1]
      elsif message =~ /^show/
        result = show
      else
        result = ["BAD COMMAND!!"]
      end
      
      result.each do |r|
        notice r
      end
    end

    def crowl
    end

    private
    def set_parameter(key, val)
      if @command.key?(key.to_sym)
        @session.config[key] = val
        Pit.set(@session.server_name, :data => @session.config)
        is_authority 
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


    def show
      result = []
      @session.config.each do |key,val|
        result << "#{key} #{val}"
      end

      result
    end

    def is_authority
      if !@session.config["url"].nil? && !@session.config["key"].nil?
        @session.on_join(nil, [@session.owner_channel])
      end
    end

  end
end
