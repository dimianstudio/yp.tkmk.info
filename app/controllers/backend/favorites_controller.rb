class Backend::FavoritesController < BackendController
  
  # GET backend/favorites.html -------------------------------------- HTML
  def index
    @favorites = Favorite.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
end
