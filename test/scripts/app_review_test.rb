# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/script_helper.rb'

class AppReviewTest < Test::Unit::TestCase
  def setup
    @obj = AppReview.new
  end

  # def teardown
  # end

  def test_is_app_store_app
    assert_equal(true, @obj.is_app_store_app(1234))
    assert_equal(false, @obj.is_app_store_app('com.example'))
    assert_equal(false, @obj.is_app_store_app(nil))
  end
end
