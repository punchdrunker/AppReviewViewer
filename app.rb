# -*- encoding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require File.dirname(__FILE__) + '/config/init'


use Rack::Session::Cookie,
  :expire_after => 2592000,
  :secret => 'ChangeMe'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  def partial(page, locals = {}, options={})
    erb page.to_sym, options.merge!(:layout => false), locals
  end

  def formatted_date(date_string)
    return '' if date_string.to_s == ''
    date = Time.parse(date_string)
    date.strftime("%Y/%m/%d")
  end

  def add_wbr(s)
    s.gsub!('<br />',"\n")
    return s.scan(/.{1,4}/).join("<wbr>").gsub("\n", "<br />")
  end
end

get '/' do
  @apps = Apps.all
  @app  = nil

  if params[:app_id]
    @app = Apps.filter(:app_id => params[:app_id]).first
  else
    @app = @apps.first
  end

  if @app
    if params[:version] && params[:version]!='ALL'
      @version = params[:version].to_s
      @reviews = Reviews.filter(:app_id => @app[:app_id], :version => params[:version])
    else
      @reviews = Reviews.filter(:app_id => @app[:app_id])
    end
    @keywords = _get_keywords(@reviews)
    @stars = _get_star_count(@reviews)
    @versions = Reviews.versions(@app[:app_id]).sort_by{|val| -val[:version].to_f}
  else
    @stars = _get_star_count
  end

  erb :index
end

post '/app/create' do
  begin
  app = Apps.create(:app_id =>  params[:app_id],
                    :name => params[:app_name],
                    :created_at => Time.now)
  'ok'
  rescue => exception
    log.debug(exception)
    halt 403, "bad parameters"
  end
end

def _get_star_count(reviews=[])
  stars = [0,0,0,0,0]
  reviews.each do |review|
    key = review[:star].to_i - 1
    stars[key] += 1
  end
  return stars
end

def _get_keywords(reviews=[])
  keywords = {}
  reviews.each do |review|
    if review[:nodes]
      nodes = review[:nodes].split(',')
      nodes.each do |node|
        if keywords[node]
          keywords[node] += 1
        else
          keywords[node] = 1
        end
      end
    end
  end
  return keywords.sort_by{|key, value| -value}
end
