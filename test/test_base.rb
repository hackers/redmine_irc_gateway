require 'test/unit'
require 'redmine_irc_gateway'

class RedmineIRCGatewayTest < Test::Unit::TestCase
  def test_module_version
    version = open("#{File.expand_path('../../', __FILE__)}/VERSION").read.strip
    assert_equal version, RedmineIRCGateway::VERSION
  end
end
