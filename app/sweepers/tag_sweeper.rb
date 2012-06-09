class TagSweeper < ActionController::Caching::Sweeper

  observe Tag
  include ExpireCache
  
  def after_tags_create
    expire_cache_tag
  end
  
  def after_tags_update
    expire_cache_tag
  end
  
  def after_tags_destroy
    expire_cache_tag
  end
  
  private
  
  def expire_cache_tag
    expire_file("index.html")
    expire_files("orgs/*/tags.html")
    expire_dir("tag/")
  end
end