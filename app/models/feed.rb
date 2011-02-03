class Feed < ActiveRecord::Base
  has_many :items, :order => "id DESC"
  has_many :feed_tags
  has_many :tags, :through => :feed_tags

  def self.find_all_with_unread
    #fields = self.columns.map {|f| "f." + f.name }.join(",")
    #self.find_by_sql("SELECT #{fields}, COUNT(i.id)-SUM(i.seen) AS unread FROM feeds f, items i WHERE i.feed_id=f.id GROUP BY #{fields} ORDER BY f.id")    
    #self.find_by_sql("SELECT #{fields}, COUNT(i.id) AS unread FROM feeds f, items i WHERE i.feed_id=f.id AND i.seen IS NULL GROUP BY #{fields} ORDER BY f.id")
    self.find(:all, :conditions => ["unread > 0"], :order => :id)
  end
  
  def unread_items
    Item.find_all_by_feed_id_and_seen(self.id, nil, :order => "id DESC")
  end
  
  def mark_as_read(item_id = nil)
    if (item_id)
      connection.update("UPDATE items SET seen=1 WHERE feed_id=#{self.id} AND seen IS NULL AND id >= #{item_id}")
    else
      connection.update("UPDATE items SET seen=1 WHERE feed_id=#{self.id} AND seen IS NULL")
    end
    update_unread
  end
  
  def update_unread
    unread = Item.where(:feed_id => self.id, :seen => nil).size
    puts "unread = #{unread}"
    self.unread = unread
    self.save!
  end
  
end
