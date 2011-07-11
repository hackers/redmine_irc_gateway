require 'bundler/gem_tasks'

namespace :rig do
  namespace :development do
    desc 'Setup development environments'
    task  :setup do
      sh 'rvm use 1.8.7'
      sh 'rvm gemset create rig'
      sh 'rvm gemset use rig'
      sh 'gem install bundler'
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
