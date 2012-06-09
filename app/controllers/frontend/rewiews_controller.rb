class Frontend::RewiewsController < FrontendController
  
  # Access 
  # - all             :index
  # - admin and user  :create
  require_role ["admin", "user"], :only => :create
  
  # Filters
  before_filter :init_org
  
  # Cache sweepers
  cache_sweeper :rewiew_sweeper, :only => :create
  
  # Caching index as page
  caches_page :index

  # GET /orgs/1/rewiews.html ---------------------------------------- HTML
  # GET /orgs/1/rewiews/page/1.html --------------------------------- HTML
  def index    
    @rewiews = @org.rewiews.paginate(:page => params[:page], :per_page => 5, :order => 'created_at DESC') 
  end
  
  # POST /orgs/1/rewiews.js ------------------------------------------ AJAX
  # POST /orgs/1/rewiews/create.js ----------------------------------- AJAX /for passenger/
  def create
    raise Rewiew::NoRequiredFields if !params[:rewiew] || params[:rewiew][:text].blank?
    rewiew = Rewiew.add!(params[:org_id], current_user.id, params[:rewiew][:text] )
    respond_success rewiew, "Спасибо за отзыв!!!" 
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
    respond_error
  rescue Rewiew::RecordExist, Rewiew::NoRequiredFields => e
    respond_error e.message
  end
  
  private
  
  def init_org
    @org = Org.find(params[:org_id])
  end
  
  def respond_success(rewiew, msg)   
    respond_to do |format|
      format.html { 
        flash[:notice] = msg
        redirect_to :back
      }
      format.js { render :partial => "success", :layout => false, :locals => {:rewiew => rewiew, :msg => msg}}
    end
  end
  
  def respond_error(msg = "Извините, произошла ошибка!!!")    
    respond_to do |format|
      format.html { 
        flash[:error] = msg
        redirect_to :back
      }
      format.js { render :partial => 'error', :layout => false, :locals => {:msg => msg}}
    end
  end
end