module RedmineIRCGateway
  class User

    attr_reader  :nick, :key, :profile, :channels

    class << self

      def start_session params
        self.new params
      end

    end

    def initialize params
      @nick    = params[:nick]
      @key     = params[:key]
      @profile = params[:profile]
    end

    def connect_redmine
      Redmine::API.session = self
    end

    def channels
      @channels ||= Channel.all_by_me self
    end

  end
end
