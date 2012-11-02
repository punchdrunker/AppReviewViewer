# -*- encoding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'open-uri'

$LOAD_PATH << File.dirname(__FILE__)
require 'abstract_review'

class AppStoreReview < AbstractReview

  def initialize
    super
  end

  def get_reviews(doc, app_id)
    users = []
    versions = []
    dates = []
    i = 0
    ns = {
      "itms" => "http://www.apple.com/itms/",
    }

    doc.xpath('.//itms:TextView[@topInset="0"][@styleSet="basic13"][@squishiness="1"][@leftInset="0"][@truncation="right"][@textJust="left"][@maxLines="1"]', ns).each do |elm|
      if elm.content =~ /by/
        tmp_array = elm.content.gsub(" ", "").split("\n")
        info = []
        tmp_array.each do |v|
          if v!=""&&v!="-"&&v!="by"
            info.push v
          end
        end
        users.push info[0]

        if info[1]
          versions.push(get_version(info[1]))
        else
          versions.push("")
        end

        if info[2]
          dates.push(info[2])
        else
          dates.push("")
        end
      end
    end

    titles = []
    doc.xpath('.//itms:TextView[@styleSet="basic13"][@textJust="left"][@maxLines="1"]', ns).each do |elm|
      elm.xpath('.//itms:b',ns).each do |e|
        titles.push e.content
      end
    end

    stars = []
    doc.xpath('.//itms:HBoxView[@topInset="1"]', ns).each do |elm|
      stars.push elm.values[1]
    end

    bodies = []
    doc.xpath('.//itms:TextView[@styleSet="normal11"]', ns).each do |elm|
      bodies.push(elm.content.gsub("\n", "<br />"))
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
        :app_id => app_id
      }
      items.push(item)
    end
    return items
  end

  def fetch_reviews(app_id, pages)
    base_url = "https://itunes.apple.com"

    user_agent = "iTunes/9.2 (Windows; Microsoft Windows 7 "\
                              + "Home Premium Edition (Build 7600)) AppleWebKit/533.16"

    (0..pages).each do |page|
      puts "processing ID:#{app_id} #{(page+1).to_s}/#{(pages+1).to_s}...\n"

        url = base_url + "/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id="\
        + app_id + "&pageNumber="+page.to_s+"&sortOrdering=4&type=Purple+Software"
      xml = open(url,
                 'User-Agent' => user_agent,
                 'X-Apple-Store-Front' => '143462-1'
                ).read
      document = Nokogiri::XML(xml)
      reviews = get_reviews(document, app_id)
      insert_reviews(reviews)
    end
  end

  def get_version(text)
    version = nil
    if /Version([\d\.]+)/ =~ text
      version = $1
    end
    return version
  end
end
