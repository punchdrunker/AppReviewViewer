# -*- encoding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'time'

$LOAD_PATH << File.dirname(__FILE__)
require 'abstract_ranking'

class AppStoreRanking < AbstractRanking

  STORE_TYPE = 0

  def fetch_ranking(opt)
    if opt[:limit]==nil
      opt[:limit] = 100
    end

    if opt[:genre]==nil || opt[:genre].empty?
      url = "http://itunes.apple.com/jp/rss/topfreeapplications/limit=#{opt[:limit].to_s}/xml"
    else 
      url = "https://itunes.apple.com/jp/rss/topfreeapplications/limit=#{opt[:limit].to_s}/genre=#{opt[:genre]}/xml"
    end

    xml = open(url).read
    rankings = parse_rankings(xml)
    register_apps(rankings)
    register_rankings(rankings, opt)
  end

  def parse_rankings(xml)
    document = Nokogiri::XML(xml)
    ns = {
      "atom" => "http://www.w3.org/2005/Atom",
      "im" => "http://itunes.apple.com/rss"
    }

    apps = []
    rank = 1
    document.xpath('.//atom:entry', ns).each do |elm|
      app = {}
      app["store_type"] = STORE_TYPE
      app["app_id"]     = elm.xpath('.//atom:id',ns)[0]["im:id"].to_s
      app["name"]       = elm.xpath('.//im:name',ns)[0].content
      app["genre"]      = elm.xpath('.//atom:category',ns)[0]["label"]
      app["developer"]  = elm.xpath('.//im:artist',ns)[0].content
      app["url"]        = elm.xpath('.//atom:link',ns)[0]["href"]
      app["thumbnail"]  = elm.xpath('.//im:image[@height="100"]',ns)[0].content
      app["rank"]       = rank
      apps.push app

      rank += 1
    end

    return apps
  end
end
