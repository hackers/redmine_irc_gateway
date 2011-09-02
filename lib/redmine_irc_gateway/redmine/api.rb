require 'active_resource'

module RedmineIRCGateway
  module Redmine
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

        attr_accessor :key

        # see [REST issues response with issue count limit and offset](http://www.redmine.org/issues/6140)
        def inherited(child)
          child.headers['X-Redmine-Nometa'] = '1'
        end

        def find(*args)
          scope   = args.slice!(0)
          options = args.slice!(0) || {}
          api_key = { :key => API.key }

          if options[:params]
            options[:params].merge! api_key
          else
            options[:params] = api_key
          end

          super scope, options
        rescue => e
          self.logger.error e.to_s
          nil
        end

        def all(params = nil)
          super({ :params => params })
        end

      end

    end
  end
end
