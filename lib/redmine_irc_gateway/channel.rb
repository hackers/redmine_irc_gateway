module RedmineIRCGateway
  class Channel

    attr_reader :name, :users, :project_id

    def initialize(name, project_id, users = [])
      @name       = "##{name}"
      @users      = users
      @project_id = project_id
    end

    def talk(message)
      Order.send(message.order).each do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield [@name, "Order Not Found"]
    rescue => e
      yield [@name, "Order Error"]
    end

  end
end
