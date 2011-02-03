#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'

module Getter
  class SimpleContent
    attr_reader :url, :title, :content
    
    def initialize(item)
      @item = item
      @url = item.link
      @title = item.title
      @content = CGI::unescapeHTML(item.description.to_s)
    end
  end
end