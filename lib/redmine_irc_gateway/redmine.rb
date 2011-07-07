#!/usr/bin/env ruby

require 'rubygems'
require 'active_resource'


class RestAPI < ActiveResource::Base
  self.site = 'http://pj.es.occ.co.jp'
  self.user = 'admin'
  self.password = 'project@1171'
end

class Project < RestAPI; end
class Issue   < RestAPI; end

puts Issue.find(:all)
