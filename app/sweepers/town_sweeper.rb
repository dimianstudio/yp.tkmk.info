class TownSweeper < ActionController::Caching::Sweeper

  observe Town
  include ExpireCache
  
  def after_towns_create
    expire_cache_town
  end
  
  def after_towns_update
    expire_cache_town
  end
  
  def after_towns_destroy
    expire_cache_town
  end
  
  private
  
  def expire_cache_town
    expire_file("orgs.html")
    expire_files("orgs/*.html")
    expire_dir("orgs/page/")
    expire_files("categories/*.html") 
    expire_dirs("categories/*/")       
    expire_dir("tag/")
    expire_fragment(%r{favorite/*})
    expire_fragment(%r{select_towns})
  end
end