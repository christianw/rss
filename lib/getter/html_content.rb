#!/usr/bin/env ruby

require 'hpricot'
require 'open-uri'
require 'getter/simple_content'

module Getter
  class HtmlContent < SimpleContent
    def initialize(item)
      super(item)
      @doc = Hpricot(`curl -Ls "#{@url}"`)
      refresh = @doc.at("meta[@http-equiv='refresh']")
      if (refresh)
        @doc = Hpricot(`curl -Ls "#{refresh['content'].sub(/.*=/, '')}"`)
      end
    end
  end
end