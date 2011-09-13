module RedmineIRCGateway
  class User

    cattr_reader :session
    attr_reader  :nick, :key, :profile, :channels

    def initialize(params)
      @nick    = params[:nick]
      @key     = params[:key]
      @profile = params[:profile]

      @@session = self
    end

    def channels
      @channels ||= Channel.all
    end

    class << self

      def start_session(params)
        self.new(params)
      end

    end

  end
end
