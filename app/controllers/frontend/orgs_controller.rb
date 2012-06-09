class Frontend::OrgsController < FrontendController
  
  layout "frontend/index"
  
  # Access 
  # - all             :show
  # - admin and user  :create, :new, :update, :edit, :destroy, :delete
  require_role ["admin", "user"], :except => :show
  
  # Filters
  before_filter :init_org, :only => [:show, :edit, :update, :destroy, :delete] 
  
  # Caching index and show action as page
  # caches_page :show
  
  # GET /orgs/1.html ------------------------------------------------ HTML
  def show
  end
  
  # GET /orgs/new.html ---------------------------------------------- HTML
  def new
    session[:back] = request.env["HTTP_REFERER"]
  end
  
  # POST /orgs.html ------------------------------------------------- HTML
  # POST /orgs/create.html ------------------------------------------ HTML /for passenger/
  def create
    raise Request::NoRequiredFields if params[:org][:name].blank? || params[:org][:town_id].blank? || params[:org][:street_id].blank? || params[:org][:house].blank? || !params[:activities]
    Org.check(params[:org])
    Request.add( "", current_user, "org", "add", { :new_record => { :org => params[:org], :activities => params[:activities], :phones => (params[:phones] if params[:phones]) } })
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved 
    respond_error
  rescue Org::RecordExist, Request::NoRequiredFields => e
    respond_error e.message  
  end  
  
  # GET /orgs/1/edit.html ------------------------------------------- HTML
  def edit
    session[:back] = org_path params[:id]
  end
  
  # PUT /orgs/1.html ------------------------------------------------ HTML
  # PUT /orgs/1/update.html ----------------------------------------- HTML /for passenger/
  def update
    raise Request::NoRequiredFields if params[:org][:name].blank? || params[:org][:town_id].blank? || params[:org][:street_id].blank? || params[:org][:house].blank?
    Org.check(params[:org])
    Request.add( params[:id], current_user, "org", "edit", { :original_record_id => params[:id], :edit_record => params[:org] } )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Org::RecordExist, Request::NoRequiredFields => e
    respond_error e.message
  end
  
  # DELETE /orgs/1.html --------------------------------------------- HTML
  # DELETE /orgs/1/destroy.html ------------------------------------- HTML /for passenger/
  def destroy    
    session[:back] = org_path params[:id]
  end
  
  # DELETE /orgs/1/delete.html -------------------------------------- HTML
  def delete 
    raise Request::NoRequiredFields if params[:request][:msg].blank?
    Request.add( params[:id], current_user, "org", "delete", { :delete_record_id => params[:id], :msg => params[:request][:msg] } )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error "Извините, произошла ошибка!!!", org_path(params[:id])
  rescue Request::NoRequiredFields => e
    respond_error e.message, org_path(params[:id])
  end

  private

  def init_org
    @org = Org.find(params[:id])
  end
  
  def respond_success(msg, return_url = :back)
    init_session_variable
    flash[:notice] = msg
    redirect_to return_url
  end
end