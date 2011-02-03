class FeedController < RssController
  def index
    if (params[:id])
      show
    else
      @feeds = Feed.find_all_with_unread
      @title = "RSS aggregator"
    end
  end
  
  def show
    @feeds = Feed.find_all_with_unread
    if params[:all]
      @feed = Feed.find(params[:id], :include => [:items])
      @title = @feed.name
      @items = @feed.items
    else
      @feed = Feed.find(params[:id])
      @title = @feed.name
      @items = @feed.unread_items
    end
  end
  
  def previous_feed
    new_id = params[:id].to_i - 1
    if (Feed.find_by_id(new_id))
      redirect_to :action => :show, :id => new_id
    else
      redirect_to :action => :index
    end
  end
  
  def next_feed
    new_id = params[:id].to_i + 1
    if (Feed.find_by_id(new_id))
      redirect_to :action => :show, :id => new_id
    else
      redirect_to :action => :index
    end
  end
  
  def mark_as_read
    # SQL update is much faster!
    feed = Feed.find(params[:id])
    if params[:item_id]
      feed.mark_as_read(params[:item_id])
      redirect_to :action => :show, :id => params[:id]
    else
      feed.mark_as_read
    
      # try next feed
      new_id = params[:id].to_i + 1
      if (Feed.find_by_id(new_id))
        redirect_to :action => :show, :id => new_id
      else
        redirect_to :action => :index
      end
    end
  end
  
end
