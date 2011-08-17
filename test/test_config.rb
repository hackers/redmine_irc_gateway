require 'test/test_helper'

module RedmineIRCGateway
  class ConfigTest < ActiveSupport::TestCase
    def setup
      yaml = YAML::Store.new("#{File.expand_path('../../config', __FILE__)}/test.yml")
      yaml.transaction do
        yaml[:key] = 'config value'
      end
      @test = RedmineIRCGateway::Config.load 'test'
    end

    test 'Load config file' do
      assert_equal @test.key, 'config value'
    end

    test 'Save config file' do
      @test.big_project = 'super project'
      @test.key = 'overwrite'
      @test.save

      test = RedmineIRCGateway::Config.load 'test'

      assert_equal     test.key, 'overwrite'
      assert_not_equal test.key, 'config value'
      assert_equal     test.big_project, 'super project'
    end
  end
end
