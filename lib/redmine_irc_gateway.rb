#!/usr/bin/env ruby

require 'rubygems'
require 'net/irc'
require 'pit'

module RedmineIRCGateway
  require 'redmine_irc_gateway/version'
  require 'redmine_irc_gateway/message'
  require 'redmine_irc_gateway/redmine'

  autoload :Server, 'redmine_irc_gateway/server'
end
