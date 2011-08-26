require 'test/test_helper'

module RedmineIRCGateway
  module Redmine
    class IssueTest < ActiveSupport::TestCase

      test 'Check issue class' do
        assert_equal 'RedmineIRCGateway::Redmine::Issue', Issue.to_s
      end

      test 'Get all issues' do
        Issue.all.each do |i|
          assert_kind_of Issue, i
        end
      end

      test 'Get issue assigned me' do
        id = User.current.id
        Issue.assigned_me.each do |i|
          assert_equal id, i.assigned_to.id
        end
      end

      test 'Get issue watched' do
        Issue.watched.each do |i|
          assert_kind_of Issue, i
        end
      end

      test 'Check issue attributes' do
        i = Issue.assigned_me.first

        assert_kind_of Issue::AssignedTo, i.assigned_to
        assert_kind_of String, i.assigned_to.id
        assert_kind_of String, i.assigned_to.name

        assert_kind_of Issue::Author, i.author
        assert_kind_of String, i.author.id
        assert_kind_of String, i.author.name

        assert_kind_of Issue::Priority, i.priority
        assert_kind_of String, i.priority.id
        assert_kind_of String, i.priority.name

        assert_kind_of Project, i.project
        assert_kind_of String, i.project.id
        assert_kind_of String, i.project.name

        assert_kind_of Issue::Tracker, i.tracker
        assert_kind_of String, i.tracker.id
        assert_kind_of String, i.tracker.name

        assert_kind_of Issue::Status, i.status
        assert_kind_of String, i.status.id
        assert_kind_of String, i.status.name

        assert_kind_of String, i.created_on
        assert_kind_of String, i.updated_on
        assert_kind_of String, i.done_ratio
      end

      test 'Check project_id' do
        assert_kind_of String, Issue.assigned_me.first.project.id
      end

    end
  end
end
