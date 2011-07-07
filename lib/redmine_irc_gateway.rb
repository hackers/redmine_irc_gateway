#!/usr/bin/env ruby

require 'logger'
require 'pathname'
require 'yaml'

require 'rubygems'
require 'net/irc'
require 'pit'

module RedmineIRCGateway
  require './lib/redmine_irc_gateway/message'
  require './lib/redmine_irc_gateway/server'
  require './lib/redmine_irc_gateway/redmine'
end
