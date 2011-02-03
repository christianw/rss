#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class FtdContent < HtmlContent
    def content
      artikeltext = @doc.search("div.ftdColL")
      return artikeltext.inner_html
    end
    
  end
end
