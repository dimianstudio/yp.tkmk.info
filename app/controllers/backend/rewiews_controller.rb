class Backend::RewiewsController < BackendController

  # Filters
  before_filter :init_rewiew, :only => [:edit, :update]
  
  # Sweepers
  cache_sweeper :rewiew_sweeper, :only => :destroy
  
  # GET /backend/rewiews.html --------------------------------------- HTML
  def index
    @rewiews = Rewiew.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 5)
  end
  
  # GET /backend/rewiews/1.html ------------------------------------- HTML
  def show
    @org = Org.find(params[:id])
    @rewiews = @org.rewiews.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 5)    
  rescue
    respond_error "Такой организации нет :(", backend_orgs_path
  end
  
  # GET /backend/rewiews/1/edit.html -------------------------------- HTML
  def edit
    session[:back] = request.env["HTTP_REFERER"]  
  end
  
  # PUT /backend/rewiews/1.html ------------------------------------- HTML
  def update
    @rewiew.text = params[:rewiew][:text]
    @rewiew.save!
    respond_success "Комментарий успешно отредактирован", session[:back] 
  rescue
    respond_error
  end
  
  # DELETE /backend/rewiews/1.html ---------------------------------- HTML
  def destroy
    Rewiew.destroy(params[:id])
    respond_success "Комментарий успешно удален"    
  rescue
    respond_error
  end
  
private
  
  def init_rewiew
    @rewiew = Rewiew.find(params[:id])
  end
end