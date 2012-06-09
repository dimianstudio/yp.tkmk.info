class StreetSweeper < ActionController::Caching::Sweeper

  observe Street
  include ExpireCache
  
  def after_streets_create
    expire_cache_street
  end
  
  def after_streets_update
    expire_cache_street
  end
  
  def after_streets_destroy
    expire_cache_street
  end
  
  private
  
  def expire_cache_street
    expire_file("orgs.html")
    expire_files("orgs/*.html")
    expire_dir("orgs/page/")
    expire_files("categories/*.html") 
    expire_dirs("categories/*/")       
    expire_dir("tag/")
    expire_fragment(%r{favorite/*})
    expire_fragment(%r{select_streets})
  end
end