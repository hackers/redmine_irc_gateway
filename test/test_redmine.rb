require_relative 'test_helper'

module RedmineIRCGateway
  module Redmine
    class RedmineTest < ActiveSupport::TestCase

      test 'Load order module' do
        assert_kind_of Module, Redmine
      end

    end
  end
end
