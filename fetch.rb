# -*- encoding: utf-8 -*-

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sequel'
require 'digest/sha1'
require 'sequel'
require 'MeCab'
Sequel.connect('sqlite://appreview.db')

HERE = File.dirname(__FILE__)
$LOAD_PATH << HERE + '/lib'
require 'model/apps'
require 'model/reviews'

def get_nodes(text)
  mecab = MeCab::Tagger.new()
  text = text.gsub('<br />', '')
  text = text.gsub(/\[|\]|\(|\)/,'')
  text = text.gsub(/\[|\]|\(|\)/,'')
  node = mecab.parseToNode(text)
  nodes = []
  while node do
    feature = node.feature.force_encoding("utf-8")
    if (feature.split(',')[0]=="名詞" || feature.split(',')[0]=="形容詞")
      nodes.push(node.surface.force_encoding("utf-8"))
    end
    node = node.next
  end

  nodes.uniq!
  if nodes
    return nodes.join(',')
  end
  return nil
end

def insert_reviews(items)
  items.each do |item|
    hash = Digest::SHA1.hexdigest(item[:user] + item[:body])
    if Reviews.filter(:hash => hash).count == 0
      matched = item[:star].match(/\d/)
      star = matched[0].to_i
      Reviews.create(
                     :star => star,
                     :user => item[:user],
                     :date => item[:date],
                     :title => item[:title],
                     :body => item[:body],
                     :version => item[:version],
                     :app_id => item[:app_id],
                     :hash => hash,
                     :nodes => get_nodes(item[:body]),
                     :created_at => Time.now
                     )
    end
  end
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
        versions.push(info[1])
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
  base_url = "http://ax.itunes.apple.com"

  user_agent = "iTunes/9.2 (Windows; Microsoft Windows 7 "\
  + "Home Premium Edition (Build 7600)) AppleWebKit/533.16"


  (0..pages).each do |page|
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

Apps.all.each do |app|
  fetch_reviews(app[:app_id].to_s, 10)
end
