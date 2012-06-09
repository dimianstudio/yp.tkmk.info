class CategorySweeper < ActionController::Caching::Sweeper

  observe Category
  include ExpireCache
  
  def after_categories_create
    expire_cache_category      
  end
  
  def after_categories_update
    expire_cache_category   
  end
  
  def after_categories_restructure
    expire_cache_category
  end
  
  def after_categories_destroy
    expire_cache_category
  end
  
  private
  
  def expire_cache_category
    expire_file("index.html")
    expire_files("orgs/*.html")
    expire_files("orgs/*/activities.html")
    expire_dir("categories/")
    expire_files("orgs/*/activities.html")
    expire_fragment(%r{multiple_select_categories})
  end
end