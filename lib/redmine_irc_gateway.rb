require 'rubygems'
require 'net/irc'
require 'pit'

module RedmineIRCGateway
  require 'redmine_irc_gateway/version'
  require 'redmine_irc_gateway/message'
  require 'redmine_irc_gateway/redmine'

  autoload :Session, 'redmine_irc_gateway/session'
end
