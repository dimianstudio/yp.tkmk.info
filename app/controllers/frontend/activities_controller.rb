class Frontend::ActivitiesController < FrontendController
  
  # Access 
  # - all             :index
  # - admin and user  :create, :destroy, :delete
  require_role ["admin", "user"], :only => [:create, :destroy, :delete]
  
  # Filters
  before_filter :init_org, :only => [:index, :destroy]
  
  # Caching index as page
  caches_page :index
  
  # GET /orgs/1/activities.html ------------------------------------- HTML
  def index 
    @categories = @org.categories
  end
  
  # POST /orgs/1/activities.html ------------------------------------ HTML
  # POST /orgs/1/activities/create.html ----------------------------- HTML /for passenger/
  def create
    raise Request::NoRequiredFields unless params[:activities]
    Request.add( params[:org_id], current_user, "activity", "add", { :new_record => params[:activities][0..4] } )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Request::NoRequiredFields => e
    respond_error e.message
  end

  # DELETE /orgs/1/activities/1.html -------------------------------- HTML
  def destroy
    @activity = Activity.get(params[:org_id], params[:id])
    session[:back] = request.env["HTTP_REFERER"]
  rescue Activity::RecordNotFound => e
    respond_error e.message, org_activities_path(params[:org_id])
  end
  
  # DELETE /orgs/1/activities/1/delete.html ------------------------- HTML
  def delete 
    raise Request::NoRequiredFields if !params[:request] || params[:request][:msg].blank?
    Request.add( params[:org_id], current_user, "activity", "delete", { :delete_record_id => params[:id], :msg => params[:request][:msg]} )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error "Извините, произошла ошибка!!!", org_activities_path(params[:org_id])
  rescue Request::NoRequiredFields => e
    respond_error e.message, org_activities_path(params[:org_id])
  end
  
private
  
  def init_org
    @org = Org.find(params[:org_id])
  end
  
  def respond_success(msg, return_url = :back)
    init_session_variable
    flash[:notice] = msg
    redirect_to return_url
  end
end