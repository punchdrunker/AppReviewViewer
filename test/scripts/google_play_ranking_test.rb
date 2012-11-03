# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/script_helper.rb'

class GooglePlayRankingTest < Test::Unit::TestCase
  def setup
    @obj = GooglePlayRanking.new
  end

  # def teardown
  # end

  def test_get_ranking
    f = open(File.dirname(__FILE__) + '/ranking/google_play.html')
    data = f.read
    opt = {:base_url => "https://play.google.com"}
    records = @obj.get_ranking(data, opt)

    expect = {"store_type"=>1,
      "rank"=>"9",
      "app_id"=>"jp.co.mcdonalds.android",
      "url"=>
    "https://play.google.com/store/apps/details?id=jp.co.mcdonalds.android&feature=apps_topselling_free",
      "thumbnail"=>
    "https://lh3.ggpht.com/kxjCwlsfs-lcTh1kJw4ociNTX1EEa80NDpdYnL_lzfwRiIF1TbH9yA78BhBplPm6Pd4=w78-h78",
      "developer"=>"日本マクドナルド株式会社",
      "name"=>"マクドナルド公式アプリ",
      "rating"=>"評価: 星 3.6 個（良い）"}

    assert_equal(24, records.size)
    assert_equal(expect, records[8])
  end
end
