require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

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
