require 'active_resource'

module RedmineIRCGateway
  module Redmine

    class Connection < ActiveResource::Connection

      # override request method. add Redmine API Key
      def request(method, path, *arguments)
        super(method, "#{path}#{(path =~ /\?/ ? '&' : '?')}key=#{API.key}", *arguments)
      end

    end

    class API < ActiveResource::Base

      self.logger       = Logger.new STDOUT
      self.logger.level = Logger::ERROR
      self.proxy        = ENV['http_proxy'] if ENV['http_proxy']
      self.format       = :xml

      begin
        config = RedmineIRCGateway::Config.load 'config'
        self.site = config.server['site']
      rescue => e
        self.logger.error e.to_s
        self.logger.error 'Check your config/config.yml settings.'
      end

      class << self

        attr_accessor :key # Redmine API key

        # see [REST issues response with issue count limit and offset](http://www.redmine.org/issues/6140)
        def inherited(child)
          child.headers['X-Redmine-Nometa'] = '1'
        end

        def connection(refresh = false)
          @connection = Connection.new(site, format) if refresh || @connection.nil?
          @connection
        end

        def all(params = nil)
          super({ :params => params })
        end

      end

    end
  end
end
