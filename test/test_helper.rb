$: << File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'redmine_irc_gateway'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      self.site = 'http://rig-dev.fluxflex.com'
    end
  end
end

account = { :nick => 'test', :profile => 'test', :key => 'ec8d7c27ca5f9266a434bd2f053f98fd5db58c28' }
user = RedmineIRCGateway::User.start_session account
user.connect_redmine
