class Backend::PhonesController < BackendController
  
  # Filters
  before_filter :init_org, :only => [:index, :create]
  before_filter :init_phone, :only => [:edit, :update]
  after_filter :expire_cache, :only => [:create, :update, :destroy]
  
  # GET /backend/orgs/1/phones.html --------------------------------- HTML
  def index
    @phones = @org.phones.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/orgs/1/phones.html -------------------------------- HTML
  def create
    phone = @org.phones.build(params[:phone])
    phone.save!
    respond_success "Телефон успешно добавлен"    
  rescue
    respond_error
  end
  
  # GET /backend/orgs/1/phones/1/edit.html -------------------------- HTML
  def edit   
    session[:back] = request.env["HTTP_REFERER"]   
  end
  
  # PUT /backend/orgs/1/phones/1.html ------------------------------- HTML
  def update
    @phone.update_attributes!(params[:phone])
    respond_success "Телефон успешно изменен", session[:back]
  rescue
    respond_error
  end
  
  # DELETE /backend/orgs/1/phones/1.html ---------------------------- HTML
  def destroy
    Phone.delete(params[:id])
    respond_success "Телефон успешно удален"     
  rescue
    respond_error
  end

  # GET /backend/phones/add_row.html -------------------------------- AJAX
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
    @org = Org.find(params[:org_id])
    @phone = @org.phones.find(params[:id])
  end
  
  def expire_cache
    expire_file("orgs/#{params[:org_id]}/phones.html")
    expire_dirs("orgs/#{params[:org_id]}/phones/")
  end
end
