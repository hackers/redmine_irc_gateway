require 'active_resource'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      config = OpenStruct.new(Pit.get Module.nesting.last.to_s)
      self.site = config.url
      self.user = config.user
      self.password = config.password

      def self.find(*args)
        super rescue []
      end
    end
  end
end
