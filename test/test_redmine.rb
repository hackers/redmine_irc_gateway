require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Load order module' do
        assert_kind_of Module, Redmine
      end

      test 'Get online users' do
        me = User.current
        me.projects.each do |p|
          assert_kind_of Array, Redmine.online_users(p.id)
        end
      end

      test 'Check time entry class' do
        assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', TimeEntry.to_s
      end

      test 'Check version class' do
        assert_equal 'RedmineIRCGateway::Redmine::Version', Version.to_s
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
