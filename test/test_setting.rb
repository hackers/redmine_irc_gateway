require 'test/test_helper'

module RedmineIRCGateway
  class SettingTest < ActiveSupport::TestCase

    test 'Load setting module' do
      assert_kind_of Module, Setting
    end

    test 'Call help command' do
      assert_kind_of Array, Setting.help
    end

    test 'Call project command' do
      assert_kind_of Array, Setting.project
    end

  end
end
