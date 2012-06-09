class Frontend::PhonesController < FrontendController
  
  # Access 
  # - all             :index
  # - admin and user  :index, :create, :update, :edit, :destroy, :delete
  require_role ["admin", "user"], :only => [:create, :update, :edit, :destroy, :delete]
  
  # Filters
  before_filter :init_org, :except => :add_row
  before_filter :init_phone, :only => [:edit, :update, :destroy, :delete]  
  
  # Caching index action as page
  caches_page :index
  
  # GET /orgs/1/phones.html ----------------------------------------- HTML
  # GET /orgs/1/phones/page/1.html ---------------------------------- HTML
  def index    
    @phones = @org.phones.paginate(:page => params[:page], :per_page => 10, :order => 'department DESC')
  end
  
  # POST /orgs/1/phones.html ---------------------------------------- HTML
  # POST /orgs/1/phones/create.html --------------------------------- HTML /for passenger/
  def create  
    params[:phones].each do |phone|
      raise Request::NoRequiredFields if phone[:number].blank?
    end    
    Request.add( params[:org_id], current_user, "phone", "add", { :phones => params[:phones] } )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Request::NoRequiredFields => e
    respond_error e.message
  end
  
  # GET /orgs/1/phones/1/edit.html ---------------------------------- HTML
  def edit
    session[:back] = request.env["HTTP_REFERER"]
  end  
  
  # POST /orgs/1/phones/1.html -------------------------------------- HTML
  def update
    raise Request::NoRequiredFields if params[:phone][:number].blank? 
    Request.add( params[:org_id], current_user, "phone", "edit", { :original_record_id => params[:id], :edit_record => params[:phone] } )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Request::NoRequiredFields => e
    respond_error e.message
  end  
  
  # DELETE /orgs/1/phones/1.html ------------------------------------ HTML  
  def destroy
    session[:back] = request.env["HTTP_REFERER"]
  end
  
  # DELETE /orgs/1/phones/1/delete.html ----------------------------- HTML
  def delete
    raise Request::NoRequiredFields if !params[:request] || params[:request][:msg].blank?
    Request.add( params[:org_id], current_user, "phone", "delete", { :delete_record_id => params[:id], :msg => params[:request][:msg]} )
    respond_success "Спасибо, Ваш запрос отправлен", requests_path
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error "Извините, произошла ошибка!!!", org_phones_path(params[:org_id])
  rescue Request::NoRequiredFields => e
    respond_error e.message, org_phones_path(params[:org_id])
  end
  
  # GET /phones/add_row.html -------------------------------- AJAX
  def add_row
    render :update do |page|
      page.insert_html :bottom, "phones", render(:partial => "shared/elements_form/enter_phones")
    end  
  end

private

  def init_org
    @org = Org.find(params[:org_id])
  end
  
  def init_phone
    @phone = Phone.find(params[:id])
  end
  
  def respond_success(msg, return_url = :back)
    init_session_variable
    flash[:notice] = msg
    redirect_to return_url
  end
end