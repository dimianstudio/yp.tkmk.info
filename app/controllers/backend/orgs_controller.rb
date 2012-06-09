class Backend::OrgsController < BackendController
  
  # Filters
  before_filter :init_org, :only => [:update, :show, :destroy, :delete_image]
  
  # GET /backend/orgs.html ------------------------------------------ HTML
  def index
    @orgs = Org.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/orgs/1.html ---------------------------------------- HTML
  def show
    session[:back] = "show" 
  end
  
  # GET /backend/orgs/new.html -------------------------------------- HTML
  def new    
  end
  
  # POST /backend/orgs.html ----------------------------------------- HTML
  def create
    Org.transaction do
      @org = Org.new
      @org.name         = params[:org][:name]
      @org.description  = params[:org][:description]
      @org.user_id      = current_user.id
      @org.town_id      = params[:org][:town_id]
      @org.street_id    = params[:org][:street_id]
      @org.house        = params[:org][:house]
      @org.email        = params[:org][:email]
      @org.www          = params[:org][:www]
      @org.save!

      if params[:activities]
        params[:activities].each do |activity|
          @activity = Activity.new
          @activity.org_id      = @org.id
          @activity.category_id = activity
          @activity.save
        end
      end
      
      unless params[:phones].empty?
        params[:phones].each do |phone|
          @phone = Phone.new
          @phone.org_id     = @org.id
          @phone.department = phone[:department]
          @phone.number     = phone[:number]
          @phone.save
        end
      end
    end   
    expire_cache(@org.id)
    respond_success "Организация успешно добавлена", backend_org_path(@org)
  rescue
    flash[:error] = "Извините, произошла ошибка!!!"
    render :action => "new"
  end
  
  # PUT /backend/org/1.html ----------------------------------------- HTML
  def update
    @org.update_attributes!(params[:org])
    expire_cache(params[:id])
    respond_success "Информация об организации успешно изменена"
  rescue
    respond_error
  end
  
  # DELETE /backend/orgs/1.html ------------------------------------- HTML
  def destroy
    expire_cache(params[:id])
    Org.destroy(params[:id])
    if session[:back] == "show"
      session[:back] = nil
      respond_success "Организация успешно удалена", backend_orgs_path
    else
      respond_success "Организация успешно удалена"
    end
  rescue
    respond_error
  end
  
  # DELETE /backend/orgs/1/delete_image.html ------------------------ HTML
  def delete_image
    @org.image.clear
    @org.image_file_name = nil
    @org.image_content_type = nil
    @org.image_file_size = nil
    @org.image_updated_at = nil
    @org.save
    expire_cache(params[:id])
    respond_success "Фотка успешно удалена"
  rescue
    respond_error
  end
  
private

  def init_org
    @org = Org.find(params[:id])
  end

  def expire_cache(id)
    org = Org.find(id)
    expire_file("orgs/#{id}.html")
    expire_dirs("orgs/#{id}/")
    org.categories.collect{ |c| [c.id] }.each do |category|
      expire_files("categories/#{category}.html") 
      expire_dirs("categories/#{category}/")
    end
    org.tags.collect{ |t| [t.id] }.each do |tag|
      expire_files("tag/#{tag}.html") 
      expire_dirs("tag/#{tag}/")
    end
    org.favorites.collect{ |u| [u.user_id]}.each do |user|
      expire_fragment(%r{favorite/user_#{user}/page_*})
    end
    expire_fragment(%r{service_stat})
  end
end