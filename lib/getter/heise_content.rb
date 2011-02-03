#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/html_content'

module Getter
  class HeiseContent < HtmlContent
    def content
      h1 = @doc.at("h1")
      body = @doc.at("div[@class='meldung_wrapper']")
      return (h1.to_html + body.to_s)
    end
    
  end
end
