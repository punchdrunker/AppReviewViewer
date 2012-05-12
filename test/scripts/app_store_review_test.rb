# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/script_helper.rb'

class AppStoreReviewTest < Test::Unit::TestCase
  def setup
    @obj = AppStoreReview.new
  end

  # def teardown
  # end

  def test_get_reviews
    f = open(File.dirname(__FILE__) + '/reviews/app_store.txt')
    data = Nokogiri::XML(f.read)
    reviews = @obj.get_reviews(data, '333903271')
    expect = {:star=>"3 stars",
      :user=>"4268428",
      :date=>"11-May-2012",
      :title=>"落ちる",
      :body=>"アップデートしてから落ちやすい。",
      :version=>"Version4.2",
      :app_id=>"333903271"}

    assert_equal(25, reviews.size)
    assert_equal(expect, reviews[24])
  end

end
