require 'test/test_helper'

module RedmineIRCGateway
  class CommandTest < ActiveSupport::TestCase

    test 'Load command module' do
      assert_kind_of Module, Command
    end

    test 'Call list command' do
      assert_kind_of Array, Command.list
    end

    test 'Call uknown command' do
      assert_raise(NoMethodError) { Command.unknown_method }
    end

  end
end
