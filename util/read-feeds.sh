#!/bin/sh

export RAILS_ENV=production 
export PATH=/usr/local/bin:$PATH

${HOME}/ruby/rss/util/read-feeds.rb
