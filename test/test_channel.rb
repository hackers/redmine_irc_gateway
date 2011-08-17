require 'test/test_helper'

module RedmineIRCGateway
  class ChannelTest < Test::Unit::TestCase

    def test_channel_class
     assert_equal "RedmineIRCGateway::Channel", Channel.to_s
    end

  end
end

