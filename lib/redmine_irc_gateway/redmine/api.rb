require 'active_resource'

class ActiveResource::Base
  class << self
    attr_accessor :key
  end
end

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      config = OpenStruct.new(Pit.get Module.nesting.last.to_s)
      self.site = config.url
      self.key  = config.key
      self.proxy = ENV['http_proxy'] if ENV['http_proxy']
      self.logger = Logger.new STDOUT
      self.logger.level = Logger::ERROR

      class << self
        def find(*args)
          scope   = args.slice!(0)
          options = args.slice!(0) || {}
          api_key = { :key => API.key }

          if options[:params]
            options[:params] = options[:params].merge! api_key
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
