require_relative 'test_helper'

module RedmineIRCGateway
  class ChannelTest < ActiveSupport::TestCase

    test 'Check channel class' do
      assert_equal "RedmineIRCGateway::Channel", Channel.to_s
    end

    test 'Check main channel' do
      timeline = Channel.timeline

      assert_kind_of Channel, timeline
      assert_equal  '#Redmine', timeline.name
    end

  end
end
