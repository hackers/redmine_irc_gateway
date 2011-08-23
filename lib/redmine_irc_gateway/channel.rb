module RedmineIRCGateway
  class Channel

    def initialize(channel, prefix, users = [])
      @prefix = prefix
      @name = channel
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

    def crawl
      Order.all.each { |i| yield i }
    end

  end
end
