class RewiewSweeper < ActionController::Caching::Sweeper

  observe Rewiew
  include ExpireCache
  
  def after_save(rewiew)
    expire_file("orgs/#{rewiew.org.id}/rewiews.html")
    expire_dir("orgs/#{rewiew.org.id}/rewiews/")
  end
  
  def after_destroy(rewiew)
    expire_file("orgs/#{rewiew.org.id}/rewiews.html")
    expire_dir("orgs/#{rewiew.org.id}/rewiews/")
  end
end