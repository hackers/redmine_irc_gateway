module RedmineIRCGateway
  class Authority

    def initialize(pit)
      @pit = pit
    end

    def prive(channel = "", message = nil)
      if channel == @pit[:owner_channel]
        valid message
      end
    end

    private
    def valid(message)
      if @pit[:server].nil? && message.nil?
        "Please, input Redmine URL"
      elsif @pit[:url].nil?
        save_config(:url, message)
        "Please, input Redmine User"
      elsif @pit[:user].nil?
        save_config(:user, message)
        "Please, input Redmine Password"
      elsif @pit[:password].nil?
        save_config(:password, message)
        "Stored Config. MAHALO."
      else
        nil
      end
    end

    def save_config(key, value)
      @pit[key] = value
      Pit.set(@pit[:server_name], :data => @pit)
    end

  end
end
