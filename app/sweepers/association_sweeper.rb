class AssociationSweeper < ActionController::Caching::Sweeper

  observe Association
  include ExpireCache
  
  def after_associations_create
    expire_cache_association
  end
  
  def after_associations_destroy
    expire_cache_association
  end
  
  private
  
  def expire_cache_association
    expire_files("orgs/*/tags.html")
    expire_dir("tag/")
  end
end