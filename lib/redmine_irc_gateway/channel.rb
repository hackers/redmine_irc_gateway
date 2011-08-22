module RedmineIRCGateway
  class Channel

    include Net::IRC::Constants

    def initialize(channel, prefix, users = [])
      @prefix = prefix
      @name = channel
      @owner_user = users.first
    end

    def talk(message)
      Command.send(message.content.downcase.to_sym).each do |r|
        yield r
      end
    rescue NoMethodError => e
      puts e
      yield [@owner_user, "Command Not Found"]
    rescue => e
      yield [@owner_user, "Command Error"]
    end

    def crawl
      Command.all.each { |i| yield i }
    end

  end
end
