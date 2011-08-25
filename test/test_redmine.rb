require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

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

      test 'Load order module' do
        assert_kind_of Module, Redmine
      end

      test 'Call list order' do
        assert_kind_of Array, Redmine.list
      end

      test 'Call uknown order' do
        assert_raise(NoMethodError) { Redmine.unknown_method }
      end

    end
  end
end
