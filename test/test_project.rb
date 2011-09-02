require_relative 'test_helper'

module RedmineIRCGateway
  module Redmine
    class ProjectTest < ActiveSupport::TestCase

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

      test 'Get project members' do
        me = User.current
        me.projects.each do |p|
          assert_kind_of Array, p.members
          assert p.member? me
        end
      end

      test 'Check project has member' do
        me = User.current
        my_project = me.projects.first

        assert my_project.member? me
      end

    end
  end
end
