require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < Test::Unit::TestCase
      def test_project_class
        assert_equal 'RedmineIRCGateway::Redmine::Project', Project.to_s
      end

      def test_project_issues
        my_project = User.current.projects.first
        my_project.issues.each do |i|
          assert_kind_of Issue, i
        end
      end

      def test_issue_class
        assert_equal 'RedmineIRCGateway::Redmine::Issue', Issue.to_s
      end

      def test_issue_assigned_me
        my_name = User.current.name
        Issue.assigned_me.each do |i|
          assert_equal my_name, i.assigned_to.name
        end
      end

      def test_issue_watched
        Issue.watched.each do |i|
          assert_kind_of Issue, i
        end
      end

      def test_user_class
        assert_equal 'RedmineIRCGateway::Redmine::User', User.to_s
      end

      def test_user_my_projects
        User.current.projects.each do |p|
          assert_kind_of Project, p
        end
      end

      def test_time_entry_class
        assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', TimeEntry.to_s
      end

      def test_version_class
        assert_equal 'RedmineIRCGateway::Redmine::Version', Version.to_s
      end
    end
  end
end
