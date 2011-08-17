require 'test/test_helper'
require 'yaml/store'

module RedmineIRCGateway
  class ConfigTest < Test::Unit::TestCase
    def setup
      yaml = YAML::Store.new("#{File.expand_path('../../config', __FILE__)}/test.yml")
      yaml.transaction do
        yaml[:key] = 'config value'
      end
    end

    def test_load
      test = RedmineIRCGateway::Config.load 'test'
      assert_equal(test.key, 'config value')
    end
  end
end
