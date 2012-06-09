class Frontend::FavoritesController < FrontendController
  
  # Access 
  # - admin and user :index, :create, :destroy
  require_role ["admin", "user"]
    
  # Filters
  before_filter :init_org, :only => :create

  # Cache sweepers
  cache_sweeper :favorite_sweeper, :only => [:create, :destroy]
  
  # GET /profile/favorites.html ------------------------------------- HTML
  # GET /profile/favorites/page/1.html ------------------------------ HTML
  def index
    unless read_fragment("favorite/user_#{current_user.id}/page_#{params[:page] || 1}")
      @favorites = Favorite.find(:all, :conditions => ["user_id = ?", current_user.id], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    end
  end
  
  # TODO: Сделать возможным добавление в избранное без включенного JS
  # POST /orgs/1/favorites.js --------------------------------------- AJAX
  def create
    Favorite.add!( params[:org_id], current_user.id ) 
    respond_success "Организация успешно добавлена в Избранное"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Favorite::RecordExist => e
    respond_error e.message
  end
  
  # DELETE /orgs/1/favorites/1.html --------------------------------- HTML
  def destroy
    Favorite.delete_all( ["org_id = ? AND user_id = ?", params[:org_id], params[:id]] )
    respond_success "Организация успешно удалена из Избранного"
  end
  
  private
  
  def init_org
    @org = Org.find(params[:org_id])
  end
  
  def respond_success(msg)   
    respond_to do |format|
      format.html { 
        flash[:notice] = msg
        redirect_to :back
      }
      format.js { render :partial => "success", :layout => false, :locals => {:msg => msg}}
    end
  end
     
  def respond_error(msg = "Извините произошла ошибка!!!")    
    respond_to do |format|
      format.html { 
        flash[:notice] = msg
        redirect_to :back
      }
      format.js { render :partial => 'error', :layout => false, :locals => {:msg => msg}}
    end
  end
end