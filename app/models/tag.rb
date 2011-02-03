class Tag < ActiveRecord::Base
  has_many :feed_tags
  has_many :feeds, :through => :feed_tags
  has_many :items, :through => :item_tags
end
