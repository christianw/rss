class FeedTag < ActiveRecord::Base
  belongs_to :feed
  belongs_to :tag
end
