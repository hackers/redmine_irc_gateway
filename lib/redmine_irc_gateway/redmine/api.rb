require 'active_resource'

module RedmineIRCGateway
  module Redmine

    class Connection < ActiveResource::Connection

      attr_accessor :key # Redmine API key

      # override request method. add Redmine API Key
      def request(method, path, *arguments)
        super(method, "#{path}#{(path =~ /\?/ ? '&' : '?')}key=#{key}", *arguments)
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

        # override connection method at /gems/activeresource-3.1.0/lib/active_resource/base.rb
        #
        # An instance of ActiveResource::Connection that is the base \connection to the remote service.
        # The +refresh+ parameter toggles whether or not the \connection is refreshed at every request
        # or not (defaults to <tt>false</tt>).
        def connection(refresh = false)
          if defined?(@connection) || superclass == ActiveResource::Base
            @connection = Connection.new(site, format) if refresh || @connection.nil?
            @connection.proxy = proxy if proxy
            @connection.user = user if user
            @connection.password = password if password
            @connection.auth_type = auth_type if auth_type
            @connection.timeout = timeout if timeout
            @connection.ssl_options = ssl_options if ssl_options
            @connection.key = key if key
            @connection
          else
            superclass.connection
          end
        end

        def all(params = nil)
          super({ :params => params })
        end

      end

    end
  end
end
