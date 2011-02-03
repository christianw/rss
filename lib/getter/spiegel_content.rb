#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class SpiegelContent < HtmlContent
    def content
      @h1 = @doc.search("div#spArticleColumn/h1")
      @h2 = @doc.search("div#spArticleColumn/h2")
      @body = @doc.search("div#spArticleColumn/p")
      return Iconv.iconv("utf-8", "iso-8859-1", @h1.to_html + @h2.to_html + @body.map {|b| b.to_html}.join("\n"))[0]
    end
    
  end
end
