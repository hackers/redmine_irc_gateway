require 'active_resource'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      config = OpenStruct.new(Pit.get Module.nesting.last.to_s)
      self.site = config.url
      self.user = config.user
      self.password = config.password
    end
  end
end
