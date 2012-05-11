# -*- encoding: utf-8 -*-

require 'rubygems'
require 'digest/sha1'

class AbstractReview

  def initialize
    super
  end

  def get_nodes(text)
    begin
      require 'MeCab'
    rescue LoadError
      return nil
    end

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
      item[:user] = '' unless item[:user]
      item[:body] = '' unless item[:body]
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
          :device => item[:device],
          :hash => hash,
          :nodes => get_nodes(item[:body]),
          :created_at => Time.now
        )
      end
    end
  end
end
