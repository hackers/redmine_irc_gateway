require 'test/test_helper'

module RedmineIRCGateway
  class VersionTest < ActiveSupport::TestCase
    test 'Check RedmineIRCGateway version' do
      version = open("#{File.expand_path('../../', __FILE__)}/VERSION").read.strip
      assert_equal version, VERSION
    end
  end
end
