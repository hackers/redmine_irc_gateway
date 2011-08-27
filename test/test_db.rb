require 'test/test_helper'

module RedmineIRCGateway
  class DBTest < ActiveSupport::TestCase

    def setup
      @db = SDBM.open DB_PATH
    end

    def teardown
      @db.close
    end

    test 'Load databse' do
      @db.each do |k, v|
        assert_kind_of String, k
        assert_kind_of String, v
      end
    end

    test 'Load database first' do
      assert @db.values.first < @db.values.last
    end

  end
end
