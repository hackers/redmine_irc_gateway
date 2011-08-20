require 'test/test_helper'

module RedmineIRCGateway
  class CommandTest < ActiveSupport::TestCase

    test 'load command module' do
      assert_kind_of Module, Command
    end

    test 'call list command' do
      assert_kind_of Array, Command.list
    end

    test 'call uknown command' do
      assert_raise(NoMethodError) { Command.unknown_method }
    end
  end
end
