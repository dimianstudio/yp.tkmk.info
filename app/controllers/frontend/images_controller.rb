class Frontend::ImagesController < FrontendController
    
  # Access 
  # - all             :index
  # - admin and user  :create
  require_role ["admin", "user"], :only => :create
  
  # Cache sweepers
  cache_sweeper :image_sweeper, :only => :create

  # Filters
  before_filter :init_org

  # Caching index action as page
  caches_page :index

  # GET /orgs/1/images.html -------------------------------------------- HTML
  def index
    @images = @org.images
  end
  
  # POST /orgs/1/images.html ------------------------------------------- HTML
  # POST /orgs/1/images/create.html ------------------------------------ HTML /for passenger/
  def create
    raise Image::NoRequiredFields if params[:image].blank?
    @org.images.create!(params[:image])
    respond_success "Спасибо, Ваш запрос отправлен"
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Image::NoRequiredFields => e
    respond_error e.message
  end

private

  def init_org
    @org = Org.find(params[:org_id])
  end
end
