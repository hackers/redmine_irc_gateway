require 'rake/clean'

CLEAN.include('config/test.yml', 'tmp', 'log', '/tmp/rig_issues.*')

namespace :rig do
  namespace :development do
    desc 'Setup development environments'
    task  :setup do
      sh 'rvm use 1.9.2'
      sh 'rvm gemset create rig'
      sh 'rvm gemset use rig'
      sh 'gem install bundler'
      sh 'gem list'
      sh 'bundle'
      sh 'bundle show'
    end
  end

  namespace :test do
    require 'rake/testtask'
    Rake::TestTask.new 'all'
  end
end

task :default => 'rig:test:all'

begin
  require 'bundler/gem_tasks'
rescue LoadError
  abort 'NOTE: Run `$ rake rig:development:setup`'
end
