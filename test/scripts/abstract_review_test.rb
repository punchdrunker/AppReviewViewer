# -*- encoding: utf-8 -*-
$:<<File.dirname(__FILE__)
require 'script_helper'

class AbstractReviewTest < Test::Unit::TestCase
  def setup
    @obj = AbstractReview.new
  end

  # def teardown
  # end

  def test_get_nodes
    begin
      require 'MeCab'
      expect = '私,名前,中野'
    rescue LoadError
      expect = nil
    end
    assert_equal(expect, @obj.get_nodes('私の名前は中野です'))
  end

  def test_insert_reviews
    item = {
      :star => '3 stars',
      :user => 'ユーザー',
      :date => '2012/5/10',
      :title => 'タイトル',
      :body => '本文',
      :version => 'version 1.0',
      :app_id => '12345',
      :device => '',
    }
    @obj.insert_reviews([item])
    review = Reviews.filter(:app_id => 12345).first

    assert_equal(3, review[:star])
    [:user, :date, :title, :body, :version, :device].each do |check|
      assert_equal(item[check], review[check])
    end
  end

end

