require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class UserTest < ActiveSupport::TestCase

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

    end
  end
end

