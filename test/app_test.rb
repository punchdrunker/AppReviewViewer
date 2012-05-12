# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/test_helper'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_my_default
    get '/'
    assert_equal 200, last_response.status
  end

  def test_app_id
    get '/', :app_id => 123
    assert_equal 200, last_response.status
  end

  def test_with_params
    get '/meet', :name => 'Frank'
    assert_equal 404, last_response.status
  end

  def test_post_app
    post '/app/create', :app_id => 'com.example', :app_name => 'test_app'
    assert_equal 200, last_response.status
  end

end
