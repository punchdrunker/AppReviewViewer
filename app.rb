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

  def formatted_date(date_string, delimiter='/')
    date_string = date_string.to_s
    return '' if date_string == ''
    date = Time.parse(date_string)
    date.strftime("%Y#{delimiter}%m#{delimiter}%d")
  end

  def formatted_rate(str)
    return $1 if /([\d\.]+)/ =~ str
    return ''
  end

  def add_wbr(s)
    string_array = s.to_s.split('<br />')
    formatted_string_array = []
    string_array.each do |string|
      formatted_string_array.push string.scan(/.{1,4}/).join("<wbr>")
    end
    return formatted_string_array.join("<br />")
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
    @versions = Reviews.versions(@app[:app_id]).sort_by{|val| -val[:version].to_f}
    if params[:version] && params[:version]!='ALL'
      @version = params[:version].to_s
      @reviews = Reviews.filter(:app_id => @app[:app_id], :version => params[:version])
    elsif params[:version] && params[:version]=='ALL'
      @reviews = Reviews.filter(:app_id => @app[:app_id])
    elsif @versions != nil && 0 < @versions.length
      @version = @versions.first[:version]
      @reviews = Reviews.filter(:app_id => @app[:app_id], :version => @version)
    else
      @reviews = Reviews.filter(:app_id => @app[:app_id])
    end
    @keywords = _get_keywords(@reviews)
    @stars = _get_star_count(@reviews)
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

get '/ranking' do
  params[:store_type] = 0 unless params[:store_type]
  @store_type = params[:store_type]
  unless params[:date]
    now = Time.now
    params[:date] = now.year.to_s + '-' + now.month.to_s + '-' + now.day.to_s
  end
  @date = params[:date]

  @records = RankingRecords.filter(:store_type => params[:store_type],
                                   :date => Time.parse(params[:date]))\
                                   .join_table(:left, :ranking_apps___app, [:app_id]).order(:rank)

  @genres = {}
  total_count = 0
  @records.each do | record |
    next unless record[:genre]
    if @genres[record[:genre]]
      @genres[record[:genre]][:count] += 1
    else
      @genres[record[:genre]] = {}
      @genres[record[:genre]][:count] = 1
    end
    total_count += 1
  end

  @genres.each do |k, v|
    v[:share] = (v[:count].to_f / total_count.to_f) * 100.0
  end

  @date_list = RankingRecords.dates
  @apps = Apps.all

  erb :ranking
end

get '/graph' do
  if params[:app_id]
    @app = RankingApps.filter(:app_id => params[:app_id]).first
  else
    return 'not found'
  end

  @records = RankingRecords.filter(:app_id => params[:app_id])\
    .join_table(:left, :ranking_apps___app, [:app_id]).order(:rank)

  @apps = Apps.all
  erb :graph
end

get '/tsv' do
  if params[:app_id]
    @app = RankingApps.filter(:app_id => params[:app_id]).first
  else
    return ''
  end

  @records = RankingRecords.filter(:app_id => params[:app_id])\
    .join_table(:left, :ranking_apps___app, [:app_id]).order(:rank)
  tsv = ''
  @records.each do |r|
    tsv += r[:date].strftime("%Y-%m-%d") + "\t" + r[:rank].to_s + "\n"
  end

  return tsv
end

#
# private methods
#

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
      nodes = review[:nodes].to_s.split(',')
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
