require 'test/test_helper'

class ObjectTest < ActiveSupport::TestCase

  test 'object to query' do
    assert_equal 'sort=updated_on%3Adesc', ({ :sort => 'updated_on:desc' }).to_query
  end

end
