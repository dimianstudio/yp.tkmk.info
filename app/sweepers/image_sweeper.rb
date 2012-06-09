class ImageSweeper < ActionController::Caching::Sweeper

  observe Image
  include ExpireCache
  
  def after_save(image)
    expire_file("orgs/#{image.org.id}/images.html")
  end
  
  def after_destroy(image)
    expire_file("orgs/#{image.org.id}/images.html")
  end
end