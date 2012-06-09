class Frontend::MapsController < FrontendController
  
  # Access 
  # - all             :index
  # - admin and user  :index, :create
  require_role ["admin", "user"], :only => [:index, :create]
  
  # Filters
  before_filter :init_org
  
  # Caching index action as page
  # caches_page :index
  
  # GET /orgs/1/map.html -------------------------------------------- HTML
  def index   
  end
  
  # POST /orgs/1/map.html ------------------------------------------- HTMl
  # POST /orgs/1/map/create.html ------------------------------------ HTML /for passenger/
  def create
    raise Marker::NoRequiredFields if params[:markers].blank?
    # params[:markers].each do |marker|
    #       @org.markers.create!(marker)
    #     end   
    Request.add( params[:org_id], current_user, "marker", "add", { :markers => params[:markers][0..2] })
    respond_success "Спасибо, Ваш запрос отправлен"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Marker::NoRequiredFields => e
    respond_error e.message
  end
  
private

  def init_org
    @org = Org.find(params[:org_id])
  end
end
