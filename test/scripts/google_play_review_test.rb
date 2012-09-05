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

  def test_get_reviews_rare_sample
    f = open(File.dirname(__FILE__) + '/reviews/google_play_new.txt')
    data = f.read
    reviews = @obj.get_reviews(data, 'com.twitter.android')
    expect0 = {:star=>"評価: 星 5.0 個（良い）",
      :user=>"テストの名前",
      :date=>"2012/07/30",
      :title=>"4.1.1",
      :body=> "Nexus 7で動かない",
      :version=>"4.2.0",
      :device=>"HTC Desire HD",
      :app_id=>"com.twitter.android"}

    expect1 = {:star=>"評価: 星 1.0 個（あまり良くない）",
      :user=>"user2",
      :date=>"2012/09/04",
      :title=>"使えない",
      :body=> "使いやすいアプリもあれば、使いずらいアプリもある。",
      :version=>"1.0.0",
      :device=> nil,
      :app_id=>"com.twitter.android"}

    assert_equal(2, reviews.size)
    assert_equal(expect0, reviews[0])
    assert_equal(expect1, reviews[1])
  end


  def test_get_version
    text = "ユーザー名 - 2012/07/22 - Sharp IS11SH、バージョン 4.1.0 本文（テスト） テスト（テスト） "
    assert_equal('4.1.0', @obj.get_version(text))
  end

  def test_get_device
    text = "ユーザー名 - 2012/07/22 - Sharp IS11SH、バージョン 4.1.0 本文（テスト） テスト（テスト） "
    assert_equal('Sharp IS11SH', @obj.get_device(text))
  end

  def test_get_version_with_parenthese
    text = "ユーザー名（2012/04/19） （SEMC Xperia Arco、バージョン 3.3.4）本文（テスト） テスト（テスト） "
    assert_equal('3.3.4', @obj.get_version(text))
  end

  def test_get_device_with_parenthese
    text = "ユーザー名（2012/04/19） （SEMC Xperia Arco、バージョン 3.3.4）本文（テスト） テスト（テスト） "
    assert_equal('SEMC Xperia Arco', @obj.get_device(text))
  end

end
