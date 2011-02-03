class ItemController < RssController
  def show
    @item = Item.find(params[:id])
  end
  
  def add_star
    item = Item.find(params[:id])
    item.star = 1
    item.save
    format.js
  end
  
  def mark_as_read
    @item = Item.find(params[:id])
    @item.seen = 1
    @item.save
    # head :created #, :location => person_url(@person)
    # render :nothing => true, :status => "201 Created"
    respond_to do |format|
      format.js
    end
  end
  
  def add_tag
    @item = Item.find(params[:id])
    params[:tag].split(" ").each do |t|
      item.tags << Tag.find_or_create_by_tag(t)
    end
  end
  
  def expand
    @item = Item.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def collapse
    @item = Item.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def original
    @item = Item.find(params[:id])
    @item.read = 1
    @item.save
    redirect_to @item.url
  end
  
end
