require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Load order module' do
        assert_kind_of Module, Redmine
      end

      test 'Check time entry class' do
        assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', TimeEntry.to_s
      end

      test 'Check version class' do
        assert_equal 'RedmineIRCGateway::Redmine::Version', Version.to_s
      end

      test 'Call assignend me issues' do
        assert_kind_of Array, Redmine.me
      end

      test 'Call uknown command' do
        assert_raise(NoMethodError) { Redmine.unknown_method }
      end

      test 'Check build description' do
        watch_list = Issue.watched
        watch_list.each do |w|
          desc = Redmine.build_issue_description(w)
          user = w.assigned_to || w.author

          assert_equal user.name.gsub(' ', ''), desc.user
        end
      end

    end
  end
end
