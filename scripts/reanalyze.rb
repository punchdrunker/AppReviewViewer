# -*- encoding: utf-8 -*-

=begin
   Use to change DB records.
=end

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
require 'app_review'

Reviews.all.each do |r|
  #do something
  # task = AbstractReview.new
  # r[:nodes] = task.get_nodes(r[:body])
  # r.save
end
