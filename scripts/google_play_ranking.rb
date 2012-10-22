# -*- encoding: utf-8 -*-

require 'singleton'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'net/http'
require 'net/https'

$LOAD_PATH << File.dirname(__FILE__)
require 'abstract_ranking'

class GooglePlayRanking < AbstractRanking
  include Singleton

  def initialize(app_id, page)
    @html_array = []
    (0..pages).each do |page|
      http = Net::HTTP.new('play.google.com', 443)
      http.use_ssl = true
      path = "/store/getreviews"
      data = "id=#{app_id}&reviewSortOrder=0&reviewType=1&pageNum=#{page}"
      response = http.post(path, data)
      @html_array.push(JSON.parse(response.body.split("\n")[1])['htmlContent'])
    end
  end


  def fetch_ranking(app_id)
    (@html_array).each do |html|
      ranking = get_ranking(html, app_id)
      insert_ranking(ranking) if ranking
    end
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
