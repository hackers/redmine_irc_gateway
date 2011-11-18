require_relative 'test_helper'

module RedmineIRCGateway
  module Redmine
    class TimeEntryTest < ActiveSupport::TestCase

      test 'Check TimeEntry class' do
        assert_equal 'RedmineIRCGateway::Redmine::TimeEntry', TimeEntry.to_s
      end

      test 'Check my time entries' do
        TimeEntry.recent_me.each do |t|
          assert_equal t.user, User.current
        end
      end

    end
  end
end
