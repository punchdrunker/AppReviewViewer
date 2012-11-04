# -*- encoding: utf-8 -*-

require 'rubygems'
require 'nokogiri'
require 'open-uri'

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../config'
require 'abstract_ranking'

class GooglePlayRanking < AbstractRanking

  STORE_TYPE = 1

  def fetch_ranking(opt={})
    rankings = croll(opt)
    (1..7).each do |page|
      opt[:page] = page
      rankings.concat croll(opt)
    end

    register_apps(rankings)
    register_rankings(rankings, opt)
  end

  def croll(opt={})
    if opt[:page]==nil || opt[:page]==0
      url = "https://play.google.com/store/apps/collection/topselling_free"
    else 
      start = 24 * opt[:page].to_i
      url = "https://play.google.com/store/apps/collection/topselling_free?start=#{start}&num=24"
    end
    opt[:base_url] = "https://play.google.com"

    html = open(url).read
    rankings = get_ranking(html, opt)
    return rankings
  end

  def get_ranking(html, opt)
    records = [];
    doc = Nokogiri.HTML(html)
    doc.xpath('//li[@class="goog-inline-block"]').each do |node|
      app = parse_ranking_app(node, opt)
      records.push app
    end

    doc.xpath('//li[@class="goog-inline-block z-last-child"]').each do |node|
      app = parse_ranking_app(node, opt)
      records.push app
    end

    return records
  end

  def parse_ranking_app(node, opt)
      app = {}
      app["store_type"] = STORE_TYPE
      app["rank"]       = node.xpath(".//div[@class='ordinal-value']")[0].text
      app["app_id"]     = node["data-docid"]
      app["url"]        = opt[:base_url] + node.xpath(".//a")[0]["href"]
      app["thumbnail"]  = node.xpath(".//img")[0]["src"]
      app["developer"]  = node.xpath(".//a")[2].content
      app["name"]       = node.xpath(".//a")[1]["title"]
      app["developer"]  = node.xpath(".//a")[2].content
      app["rating"]     = node.xpath(".//div[@class='ratings goog-inline-block']")[0]["title"]
      return app
  end

end
