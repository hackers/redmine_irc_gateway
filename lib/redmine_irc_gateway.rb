#!/usr/bin/env ruby

$: << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'net/irc'
require 'pit'

module RedmineIRCGateway
  require 'redmine_irc_gateway/version'
  require 'redmine_irc_gateway/redmine'

  require 'redmine_irc_gateway/message'
  require 'redmine_irc_gateway/authority'
  require 'redmine_irc_gateway/session'
  require 'redmine_irc_gateway/server'
end

if __FILE__ == $0
  RedmineIRCGateway::Server.run!
end
