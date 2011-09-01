#!/usr/bin/env ruby

$: << File.expand_path('../', __FILE__) 
require 'sdbm'

require 'rubygems'
require 'net/irc'

require 'lib/net/irc/message'
require 'lib/activesupport/core_ext/object/to_query'


module RedmineIRCGateway

  DB_PATH = '/tmp/rig_issues.db'

  require 'redmine_irc_gateway/version'
  require 'redmine_irc_gateway/config'
  require 'redmine_irc_gateway/command'

  require 'redmine_irc_gateway/redmine'
  require 'redmine_irc_gateway/redmine/api'
  require 'redmine_irc_gateway/redmine/project'
  require 'redmine_irc_gateway/redmine/issue'
  require 'redmine_irc_gateway/redmine/user'
  require 'redmine_irc_gateway/redmine/time_entry'
  require 'redmine_irc_gateway/redmine/version'

  require 'redmine_irc_gateway/message'
  require 'redmine_irc_gateway/session'
  require 'redmine_irc_gateway/server'
  require 'redmine_irc_gateway/channel'
  require 'redmine_irc_gateway/console'
  require 'redmine_irc_gateway/setting'
end

if __FILE__ == $0
  RedmineIRCGateway::Server.run!
end
