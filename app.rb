# -*- encoding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sequel'
require 'logger'
require 'yaml'
require 'pp'

Sequel.connect('sqlite://appreview.db')

HERE = File.dirname(__FILE__)
$LOAD_PATH << HERE + '/lib'
require 'model/apps'
require 'model/reviews'

log = Logger.new(HERE+'/logs/debug.log')
log.level = Logger::DEBUG

use Rack::Session::Cookie,
  :expire_after => 2592000,
  :secret => 'hogefuga'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  def partial(page, locals = {}, options={})
    erb page.to_sym, options.merge!(:layout => false), locals
  end
end

configure do
#  CONFIG = YAML.load_file(HERE + '/config/config.yaml')
end

get '/' do
  @apps = Apps.all
  if params[:app_id]
    @app = Apps.filter(:app_id => params[:app_id]).first
  else
    @app = @apps.first
  end

  if @app
    @reviews = Reviews.filter(:app_id => @app[:app_id])
    @keywords = get_keywords(@reviews)
    @stars = get_star_count(@reviews)
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

def get_star_count(reviews)
  stars = [0,0,0,0,0]
  reviews.each do |review|
    key = review[:star].to_i - 1
    stars[key] += 1
  end
  return stars
end

def get_keywords(reviews)
  keywords = {}
  reviews.each do |review|
    nodes = review[:nodes].split(',')
    nodes.each do |node|
      if keywords[node]
        keywords[node] += 1
      else
        keywords[node] = 1
      end
    end
  end
  return keywords.sort_by{|key, value| -value}
end
