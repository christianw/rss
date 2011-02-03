#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class RedditContent < HtmlContent
    def url
      @doc.at("p.title/a.title")['href']
    end    
  end
end
