# -*- encoding: utf-8 -*-

require 'rubygems'
require 'sequel'

db = ''
if ARGV[0]=='test'
  db = 'sqlite::memory:'
elsif ARGV[0]=='production'
  db = 'sqlite://' + File.dirname(__FILE__) + '/../appreview.db'
else
  db = 'sqlite://' + File.dirname(__FILE__) + '/../appdebug.db'
end
Sequel.connect(db)

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
require 'model/apps'
require 'model/reviews'
require 'model/ranking_apps'
require 'model/ranking_records'
require 'app_ranking'

task = AppRanking.new
task.fetch
