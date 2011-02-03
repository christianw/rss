#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class DiggContent < HtmlContent
    def url
      @doc.at("h1#title/a")['href']
    end    
  end
end
