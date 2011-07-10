# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'redmine_irc_gateway/version'

Gem::Specification.new do |s|
  s.name        = 'redmine_irc_gateway'
  s.version     = RedmineIRCGateway::VERSION
  s.authors     = ['Tomohiro, TAIRA']
  s.email       = ['tomohiro.t@gmail.com']
  s.homepage    = 'http://github.com/hackers/redmine_irc_gateway'
  s.summary     = %q{Redmine IRC Gateway}
  s.description = %q{This project privides an access to Redmine API via IRC Gateway.}

  s.rubyforge_project = 'redmine_irc_gateway'

  s.add_dependency 'rake'
  s.add_dependency 'net-irc'
  s.add_dependency 'activeresource'
  s.add_dependency 'pit'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
