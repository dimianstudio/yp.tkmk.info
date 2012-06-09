class Frontend::TagsController < FrontendController
  
  # Access 
  # - all             :index, :show
  # - admin and user  :create
  require_role ["admin", "user"], :only => "create"
  
  # Filters
  before_filter :init_org, :except => :show
  
  # Caching index and show action as page
  caches_page :index, :show
  
  # Cache sweepers
  cache_sweeper :tag_sweeper, :only => :create
  
  # GET /orgs/1/tags.html ------------------------------------------- HTML
  def index
    @tags = @org.tags(:order => "recommended DESC")
  end
  
  # GET /tags/1.html ------------------------------------------------ HTML
  # GET /tags/1/page/1.html ----------------------------------------- HTML
  def show
    @tag = Tag.find(params[:id]) 
    @orgs = @tag.orgs.paginate(:page => params[:page], :per_page => 10, :include => [:town,:street]) 
  end
  
  # POST /org/1/tags.html ------------------------------------------- HTML
  # POST /org/1/tags/create.html ------------------------------------ HTML /for passenger/
  def create
    raise Tag::NoRequiredFields if params[:tag][:string].blank?
    tags = params[:tag][:string].downcase.split(",").reject(&:blank?).map(&:strip).uniq
    tags.each do |tag|
      Tag.transaction do
        new_tag = Tag.find_or_add(tag, current_user.id)
        Association.find_or_add(@org.id, new_tag.id, current_user.id)
      end      
    end
    respond_success "Спасибо, Ваши тэги успешно присвоены"    
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
    respond_error
  rescue Tag::NoRequiredFields => e
    respond_error e.message
  end

private  

  def init_org
    @org = Org.find(params[:org_id])
  end
end