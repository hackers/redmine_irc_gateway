#!/usr/bin/env ruby

require 'active_resource'

module RedmineIRCGateway
  class RestAPI < ActiveResource::Base
    config = OpenStruct.new(Pit.get Module.nesting.last.to_s)
    self.site = config.url
    self.user = config.user
    self.password = config.password
  end

  class Project < RestAPI; end
  class Issue   < RestAPI; end
end

#puts Issue.find(:all)
