require 'test/unit'
require 'redmine_irc_gateway'

module RedmineIRCGateway
  class RedmineTest < Test::Unit::TestCase
    def test_project_class
      assert_equal 'RedmineIRCGateway::Redmine::Project', RedmineIRCGateway::Redmine::Project.to_s
    end

    def test_issue_class
      assert_equal 'RedmineIRCGateway::Redmine::Issue', RedmineIRCGateway::Redmine::Issue.to_s
    end

    def test_user_class
      assert_equal 'RedmineIRCGateway::Redmine::User', RedmineIRCGateway::Redmine::User.to_s
    end

    def test_time_entry_class
      assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', RedmineIRCGateway::Redmine::TimeEntry.to_s
    end

    def test_version_class
      assert_equal 'RedmineIRCGateway::Redmine::Version', RedmineIRCGateway::Redmine::Version.to_s
    end
  end
end
