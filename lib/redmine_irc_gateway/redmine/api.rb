require 'active_resource'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      config = OpenStruct.new(Pit.get Module.nesting.last.to_s)
      self.site = config.url
      self.user = config.user
      self.password = config.password
      self.proxy = ENV['http_proxy'] if ENV['http_proxy']
      self.logger = Logger.new STDOUT

      class << self
        def find(*args)
          super
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
