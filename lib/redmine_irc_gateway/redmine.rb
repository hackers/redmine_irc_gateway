#!/usr/bin/env ruby

require 'rubygems'
require 'active_resource'


class RestAPI < ActiveResource::Base
  self.site = 'http://redmine.dev'
  self.user = 'admin'
  self.password = ''
end

class Project < RestAPI; end
class Issue   < RestAPI; end

puts Issue.find(:all)
