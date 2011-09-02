require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Load order module' do
        assert_kind_of Module, Redmine
      end

      test 'Check build description' do
        watch_list = Issue.watched
        watch_list.each do |w|
          desc = Redmine.build_issue_description(w)
          user = w.assigned_to || w.author

          assert_equal user.name.gsub(' ', ''), desc.speaker
        end
      end

    end
  end
end
