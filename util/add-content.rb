#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../config/environment"
require 'simple-rss'
require 'open-uri'
require 'cgi'

require 'getter/spiegel_content'


Item.find_all_by_feed_id(1).each do |i|
  #if (i.content.blank?)
    cg = Getter::HeiseContent.new(i.url)
    puts "found url #{i.url}"
    i.content = cg.content
    i.save
  #end
end
