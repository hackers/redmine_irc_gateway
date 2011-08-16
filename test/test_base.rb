require 'test/test_helper'

module RedmineIRCGateway
  class BaseTest < Test::Unit::TestCase
    def test_module_version
      version = open("#{File.expand_path('../../', __FILE__)}/VERSION").read.strip
      assert_equal version, VERSION
    end
  end
end
