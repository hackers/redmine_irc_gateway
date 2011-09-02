require_relative 'test_helper'

module RedmineIRCGateway
  class ChannelTest < ActiveSupport::TestCase

    test 'Check channel class' do
      assert_equal "RedmineIRCGateway::Channel", Channel.to_s
    end

  end
end

