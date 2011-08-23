$: << File.expand_path('../../lib', __FILE__)
$: << File.expand_path('../../test', __FILE__)

require 'test/unit'
require 'redmine_irc_gateway'

module RedmineIRCGateway
  module Redmine
    class API < ActiveResource::Base
      self.site = 'http://rig-dev.fluxflex.com'
      self.key  = 'ec8d7c27ca5f9266a434bd2f053f98fd5db58c28'
    end
  end
end
