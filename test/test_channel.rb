require_relative 'test_helper'

module RedmineIRCGateway
  class ChannelTest < ActiveSupport::TestCase

    test 'Check channel class' do
      assert_equal "RedmineIRCGateway::Channel", Channel.to_s
    end

    test 'Check main channel' do
      main = Channel.main

      assert_kind_of Channel, main
      assert_equal  '#Redmine', main.name
    end

  end
end
