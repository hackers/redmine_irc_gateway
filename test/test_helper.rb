require 'test/unit'
require 'redmine_irc_gateway'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      self.site = 'http://sandbox-98oi18xm.fluxflex.com'
      self.user = 'test'
      self.password = 'test'
    end
  end
end
