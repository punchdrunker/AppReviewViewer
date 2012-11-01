# -*- encoding: utf-8 -*-

require 'singleton'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'net/http'
require 'net/https'

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../config'
require 'abstract_ranking'

class GooglePlayRanking < AbstractRanking

  def initialize
    super
  end


  def fetch_ranking(opt={})
    begin
      require 'script_config'
    rescue LoadError
      return nil
    end

    if opt[:date]==nil || opt[:date].empty?
      opt[:date] = Time.now.strftime("%Y-%m-%d")
    end

    url = sprintf(ScriptConfig::GOOGLE_PLAY_RANKING_URL, opt[:date])

    ranking_json = open(url).read
    rankings = JSON.parse(ranking_json)
    register_apps(rankings)
    register_rankings(rankings, opt)
  end

  def get_ranking(html, app_id)
    dates = []
    titles = []
    bodies = []
    stars = []
    users = []
    versions = []
    devices = []
    i = 0

    doc = Nokogiri.HTML(html)
    doc.xpath("//h4[@class='review-title']").each do |node|
      titles.push(node.text)
    end

    doc.xpath("//p[@class='review-text']").each do |node|
      bodies.push(node.text)
    end

    doc.xpath("//span[@class='doc-review-date']").each do |node|
      dates.push(node.text.sub(' - ', ''))
    end

    doc.xpath("//div[@class='ratings goog-inline-block']").each do |node|
      stars.push(node.attributes['title'].value)
    end

    doc.xpath("//strong").each do |node|
      users.push(node.text)
    end

    doc.xpath("//div[@class='doc-review']").each do |node|
      versions.push(get_version(node.inner_html))
      devices.push(get_device(node.inner_html))
    end

    items = [];
    count = stars.size - 1
    (0..count).each do |key|
      item = {
        :star => stars[key],
        :user => users[key],
        :date => dates[key],
        :title => titles[key],
        :body => bodies[key],
        :version => versions[key],
        :device => devices[key],
        :app_id => app_id
      }
      items.push(item)
    end
    return items
  end

end
