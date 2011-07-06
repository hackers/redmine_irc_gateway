#!/usr/bin/env ruby

require 'rubygems'
require 'active_resource'


class RedmineRESTApi < ActiveResource::Base
  self.site = 'http://0.0.0.0:3000'
  self.user = 'admin'
  self.password = 'admin'
end

class Issue < RedmineRESTApi; end
class Project < RedmineRESTApi; end

puts Issue.find(1)
