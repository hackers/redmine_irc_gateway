require 'bundler/gem_tasks'
require 'rake/clean'

CLEAN.include('config/test.yml', 'tmp', 'log')

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
    $: << File.expand_path('../lib', __FILE__)
    $: << File.expand_path('../test', __FILE__)
    require 'rake/testtask'
    Rake::TestTask.new 'all'
  end
end

task :default => 'rig:test:all'
