require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Check project class' do
        assert_equal 'RedmineIRCGateway::Redmine::Project', Project.to_s
      end

      test 'Get my project issues' do
        my_project = User.current.projects.first
        my_project.issues.each do |i|
          assert_kind_of Issue, i
        end
      end

      test 'Check project has member' do
        user = User.current
        my_project = user.projects.first

        assert_equal true, my_project.member?(user)
      end

      test 'Check issue class' do
        assert_equal 'RedmineIRCGateway::Redmine::Issue', Issue.to_s
      end

      test 'Get issue assigned me' do
        my_name = User.current.name
        Issue.assigned_me.each do |i|
          assert_equal my_name, i.assigned_to.name
        end
      end

      test 'Get issue watched' do
        Issue.watched.each do |i|
          assert_kind_of Issue, i
        end
      end

      test 'Check user class' do
        assert_equal 'RedmineIRCGateway::Redmine::User', User.to_s
      end

      test 'Get my projects' do
        User.current.projects.each do |p|
          assert_kind_of Project, p
        end
      end

      test 'Check time entry class' do
        assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', TimeEntry.to_s
      end

      test 'Check version class' do
        assert_equal 'RedmineIRCGateway::Redmine::Version', Version.to_s
      end
    end

  end
end
