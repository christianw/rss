#!/usr/bin/env ruby

require 'simple-rss'
require 'open-uri'
require 'hpricot'
require 'iconv'
require 'escape_utils'

$:.push("lib")
$VERBOSE = nil

require 'getter/simple_content.rb'
require 'getter/simple_headline.rb'
require 'getter/digg_content.rb'
require 'getter/reddit_content.rb'
require 'getter/ftd_content.rb'
require 'getter/heise_content.rb'
require 'getter/html_content.rb'
require 'getter/spiegel_content.rb'
require 'getter/zeit_content.rb'

Hpricot.buffer_size = 1048576


def curl(url)
  content = `curl -Ls "#{url}"`
  begin
    if content =~ /ISO-8859/ || content =~ /iso-8859/
      return Iconv.iconv("utf-8", "iso-8859-1", content)[0]
    end
  rescue
    return Iconv.iconv("utf-8", "iso-8859-1", content)[0]
  end
  return content
end

def read_feed(f)
  begin
    if (f.headline_getter)
      rss = eval %Q{#{f.headline_getter}.parse(curl(f.url))}
    else
      # FIXME why does open/curb fail?
      rss = SimpleRSS.parse(curl(f.url))
    end
    rss.items.each do |i|
      begin
        title = i.title
        title = title.first if title.is_a? Array
        unless Item.find_by_title_and_feed_id(title, f.id)
          item = Item.new
          item.feed = f
          # use content getter to get the url and content for this
          cg = eval "#{f.content_getter}.new(i)" 
          # better, but might lead to duplicates:
          # item.title = cg.title
          # worse but safe:
          item.title = title
          item.content = cg.content
          item.url = cg.url
          item.save rescue nil
        else
          #cg = eval "#{f.content_getter}.new(i)" 
          #puts "content = #{cg.content}"
          #return
        end
      rescue
        puts "title = #{title}"
        puts "error " + $!
        nil
      end
    end
    f.last_checked = Time.now
    f.update_unread
    f.save
  rescue
    puts "error with feed #{f.name}: #{$!}"
  end
end

if (ARGV && ARGV.size > 0)
  ARGV.each do |id|
    f = Feed.find_by_id(id.to_i)
    read_feed(f) if f
  end
else
  Feed.find(:all, :order => :id).each do |f|
    puts "handling feed #{f.name}"
    read_feed(f)
  end
end
