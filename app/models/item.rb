class Item < ActiveRecord::Base
  belongs_to :feed
  has_many :item_tags
  has_many :tags, :through => :item_tags
  
  SHORT = 500
  
  def long?
    clean_content && clean_content.size > SHORT
  end
  
  def short_content
    if content && content.size < SHORT
      content
    elsif clean_content
      clean_content[0..SHORT]
    else
      nil
    end
  end

  # FIXME: use Hpricot for this
  def clean_content
    return @clean_content if @clean_content
    if content.blank?
      @clean_content = nil
    else
      c = remove_script
      # now replace any tags
      c.gsub!(%r{<[^>]*>}im, " ")
      @clean_content = c
    end
  end

  def remove_script
    return @remove_script if @remove_script
    # first replace <script> tags within scripts
    c = content.gsub(%r{"</*script[^>]*>"}im, " ")
    # now empty <script> containers 
    c.gsub!(%r{<script[^>]*>.*?[^"]</script>}im, " ")
    # and replace //-->
    @remove_script = c.gsub(%r{//-->}m, "")
  end
end
