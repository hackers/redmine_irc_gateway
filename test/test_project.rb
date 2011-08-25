require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Check project class' do
        assert_equal 'RedmineIRCGateway::Redmine::Project', Project.to_s
      end

      test 'Check project attributes' do
        p = Project.all.first

        assert_kind_of String, p.id
        assert_kind_of String, p.name
        assert_kind_of String, p.identifier
      end

      test 'Get project issues' do
        p = Project.all.first

        p.issues.each do |i|
          assert_kind_of Issue, i
        end
      end

    end
  end
end
