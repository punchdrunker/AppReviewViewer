# -*- encoding: utf-8 -*-

require 'rubygems'

$LOAD_PATH << File.dirname(__FILE__)
require 'app_store_ranking'
require 'google_play_ranking'

class AppRanking

  def initialize
    super
  end

  def fetch
    fetch_apple_ranking
    fetch_google_ranking
  end

  def fetch_apple_ranking
    opt = {:limit=>200,:store_type=>0}
    # Social networking
    # opt[:genre] = '6005'
    
    task = AppStoreRanking.new
    task.fetch_ranking(opt)

  end

  def fetch_google_ranking
    opt = {:store_type => 1}
    task = GooglePlayRanking.new
    task.fetch_ranking(opt)
  end
end
