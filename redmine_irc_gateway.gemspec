$:.push File.expand_path('../lib', __FILE__)
require 'redmine_irc_gateway/version'

Gem::Specification.new do |s|
  s.name        = 'redmine_irc_gateway'
  s.version     = RedmineIRCGateway::VERSION
  s.authors     = ['Tomohiro, TAIRA', 'Naoto, SHINGAKI', 'Yusaku, ONO']
  s.email       = ['tomohiro.t@gmail.com', 'n.shingaki@gmail.com']
  s.homepage    = 'https://github.com/hackers/redmine_irc_gateway'
  s.summary     = %q{Redmine IRC Gateway}
  s.description = %q{This project provides an access to Redmine API via IRC Gateway.}

  s.rubyforge_project = 'redmine_irc_gateway'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'watchr'

  s.add_runtime_dependency 'net-irc'
  s.add_runtime_dependency 'activeresource'
  s.add_runtime_dependency 'foreverb'
  s.add_runtime_dependency 'slop'
end
