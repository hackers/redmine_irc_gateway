require 'test/test_helper'

module RedmineIRCGateway
  class OrderTest < ActiveSupport::TestCase

    test 'Load order module' do
      assert_kind_of Module, Order
    end

    test 'Call list order' do
      assert_kind_of Array, Order.list
    end

    test 'Call uknown order' do
      assert_raise(NoMethodError) { Order.unknown_method }
    end

  end
end
