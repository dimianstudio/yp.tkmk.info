class FavoriteSweeper < ActionController::Caching::Sweeper

  observe Favorite
  
  def after_favorites_create
    expire_fragment(%r{favorite/user_#{session[:user_id]}/page_*})
  end
  
  def after_favorites_destroy
    expire_fragment(%r{favorite/user_#{session[:user_id]}/page_*})
  end
end