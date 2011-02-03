#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../config/environment"

Feed.find(:all).each do |f|
  name = f.name.gsub(/ /, "_").downcase
  f.tags << Tag.find_or_create_by_tag(name)
  f.tags << Tag.find_or_create_by_tag("mac") if (name =~ /mac/i || name =~ /apple/i)
  f.tags << Tag.find_or_create_by_tag("rails") if (name =~ /rail/i)
  puts "tag for #{f.name}: #{name}"
end