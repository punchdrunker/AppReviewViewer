require 'rubygems'
require 'sequel'
require 'test/unit'

Sequel.connect('sqlite::memory:')

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../../lib'
$LOAD_PATH << File.dirname(__FILE__) + '/../../scripts'

require 'model/apps'
require 'model/reviews'
require 'model/ranking_apps'
require 'model/ranking_records'
require 'app_review'
require 'app_ranking'
