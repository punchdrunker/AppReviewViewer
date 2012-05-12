require 'rubygems'
require 'sequel'
require 'test/unit'

Sequel.connect('sqlite::memory:')

$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../../lib'
$LOAD_PATH << File.dirname(__FILE__) + '/../../scripts'

require 'model/apps'
require 'model/reviews'
require 'app_review'
