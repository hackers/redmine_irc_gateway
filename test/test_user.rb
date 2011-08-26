require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class UserTest < ActiveSupport::TestCase

      test 'Check user class' do
        assert_equal 'RedmineIRCGateway::Redmine::User', User.to_s
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

      test 'Get user full name' do
        u = User.current

        assert_equal u.lastname + u.firstname, u.name
      end

      test 'Check User attributes' do
        u = User.current

        assert_kind_of String, u.id
        assert_kind_of String, u.mail
        assert_kind_of String, u.name
        assert_kind_of String, u.lastname
        assert_kind_of String, u.firstname
        assert_kind_of String, u.created_on
        assert_kind_of String, u.last_login_on
      end

    end
  end
end

