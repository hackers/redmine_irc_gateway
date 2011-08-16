#!/usr/bin/env ruby

$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'net/irc'
require 'pit'

module RedmineIRCGateway
  require 'redmine_irc_gateway/version'

  require 'redmine_irc_gateway/redmine/api'
  require 'redmine_irc_gateway/redmine/project'
  require 'redmine_irc_gateway/redmine/issue'
  require 'redmine_irc_gateway/redmine/user'
  require 'redmine_irc_gateway/redmine/time_entry'
  require 'redmine_irc_gateway/redmine/version'

  require 'redmine_irc_gateway/message'
  require 'redmine_irc_gateway/authority'
  require 'redmine_irc_gateway/session'
  require 'redmine_irc_gateway/server'
  require 'redmine_irc_gateway/channel'
  require 'redmine_irc_gateway/console'
end

if __FILE__ == $0
  RedmineIRCGateway::Server.run!
end
