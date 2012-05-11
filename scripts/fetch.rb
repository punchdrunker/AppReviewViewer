# -*- encoding: utf-8 -*-

require 'rubygems'
require 'sequel'
$LOAD_PATH << File.dirname(__FILE__)
$LOAD_PATH << File.dirname(__FILE__) + '/../lib'

Sequel.connect('sqlite://../appreview.db')

require 'model/apps'
require 'model/reviews'
require 'app_review'

task = AppReview.new
task.fetch
