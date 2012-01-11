require 'rake/clean'

CLEAN.include('config/test.yml', 'tmp', 'log', '/tmp/rig_issues.*')

namespace :rig do
  namespace :test do
    require 'rake/testtask'
    Rake::TestTask.new 'all'
  end
end

task :default => 'rig:test:all'
