module RedmineIRCGateway
  class User

    cattr_reader :session
    attr_reader  :nick, :key, :profile, :channels

    class << self
      def start_session params
        self.new params
      end
    end

    def initialize(params)
      @nick    = params[:nick]
      @key     = params[:key]
      @profile = params[:profile]

      @@session = self
    end

    def channels
      @channels ||= Channel.all
    end

  end
end
