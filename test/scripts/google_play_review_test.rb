# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/script_helper.rb'

class GooglePlayReviewTest < Test::Unit::TestCase
  def setup
    @obj = GooglePlayReview.new
  end

  # def teardown
  # end

  def test_get_reviews
    f = open(File.dirname(__FILE__) + '/reviews/google_play.txt')
    data = f.read
    reviews = @obj.get_reviews(data, 'com.twitter.android')
    expect = {:star=>"評価: 星 4.0 個（良い）",
      :user=>"か",
      :date=>"2012/04/30",
      :title=>"ようこそ？",
      :body=>
    "複数アカウントも扱い易くなり気に入りましたが、ログイン状態が保持されなくなりました。毎回Twitterへようこそ！画面から。仕様なら使えないです。もう少し試してみます…",
      :version=>"3.2.1",
      :device=>"Sharp INFOBAR A01",
      :app_id=>"com.twitter.android"}

    assert_equal(10, reviews.size)
    assert_equal(expect, reviews[8])
  end

end
