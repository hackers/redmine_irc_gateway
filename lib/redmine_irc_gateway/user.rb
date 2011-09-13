module RedmineIRCGateway
  class User

    # user stack
    @@users = {}

    attr_reader :nick, :key, :channels, :connection

    def initialize(params = nil)
      if params
        @nick = params[:nick]
        @key  = params[:key]
      end

      @@users[@nick.to_sym] = self
    end

    def channels
      @channels ||= Channel.all
    end

    # @TODO Create user connection
    def connection_establishment
      Redmine::API.key = @key
    end

    # @TODO Return connection object to the Redmine
    def connection
      connection = [] #dummy
    end

    class << self

      # Find user at stack
      def find(name)
        @@users[name.to_sym]
      end

    end

  end
end
