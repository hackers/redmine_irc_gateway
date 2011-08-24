module RedmineIRCGateway
  class Channel

    attr_reader :name, :users, :project_id

    def initialize(name, users = [])
      @name = name
      @users = users
      @owner_user = users.first
    end

    def talk(message)
      Order.send(message.order).each do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield [@owner_user, "Order Not Found"]
    rescue => e
      yield [@owner_user, "Order Error"]
    end

  end
end
