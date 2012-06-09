class Frontend::RequestsController < FrontendController

  # Access 
  # - admin and user  :index
  require_role ["admin", "user"]
  
  # GET /profile/requests.html -------------------------------------- HTML
  # GET /profile/requests/page/1.html ------------------------------- HTML
  def index
    @requests = Request.find(:all, :conditions => ["user_id = ?", current_user.id], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 5)
  end
end
