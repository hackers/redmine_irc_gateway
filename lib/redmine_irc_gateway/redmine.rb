# encoding: utf-8

module RedmineIRCGateway
  module Redmine
    extend self

    require 'redmine_irc_gateway/redmine/api'
    require 'redmine_irc_gateway/redmine/project'
    require 'redmine_irc_gateway/redmine/issue'
    require 'redmine_irc_gateway/redmine/user'

  end
end
