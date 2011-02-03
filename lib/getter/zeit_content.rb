#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class ZeitContent < HtmlContent
    def content
      @doc = Hpricot(`curl -Ls "#{@url}?page=all"`)
      artikeltext = @doc.search("div#main")
      return artikeltext.inner_html
    end
    
  end
end
