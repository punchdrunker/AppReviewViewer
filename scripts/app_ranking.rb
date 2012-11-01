# -*- encoding: utf-8 -*-

require 'rubygems'

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../config'
require 'app_store_ranking'
#require 'google_play_review'

class AppRanking

  def initialize
    super
  end

  def fetch
    fetch_apple_ranking
    fetch_google_ranking
  end

  def fetch_apple_ranking
    opt = {:limit=>200}
    # Social networking
    # opt[:genre] = '6005'
    
    task = AppStoreRanking.new
    task.fetch_ranking(opt)

  end

  def fetch_google_ranking
  end
end
