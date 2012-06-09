class Backend::AssociationsController < BackendController

  # Filters
  before_filter :init_org, :only => [:show, :create]
  
  # Sweepers
  cache_sweeper :association_sweeper, :only => [:create, :destroy]
    
  # GET /backend/associations.html ---------------------------------- HTML
  def index
    @associations = Association.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/orgs/1/associations.html --------------------------- HTML
  def show
    @associations = @org.associations.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/orgs/1/associations.html -------------------------- HTML
  def create
    raise Tag::NoRequiredFields if params[:tag][:string].blank?
    tags = params[:tag][:string].downcase.split(",").reject(&:blank?).map(&:strip).uniq
    user = current_user.id    
    tags.each do |tag|
      Tag.transaction do
        new_tag = Tag.find_or_add(tag, user)
        Association.find_or_add(@org.id, new_tag.id, user)
      end      
    end
    respond_success("Ассоциация(-и) успешно добавлена(-ы)")
  rescue Tag::NoRequiredFields => e
    respond_error e.message
  end
  
  # GET /backend/associations/1/tag.html ---------------------------- HTML
  def tag
    @tag = Tag.find(params[:id])
    @associations = @tag.associations(:order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/associations/1/user.html --------------------------- HTML
  def user
    @user = User.find(params[:id])
    @associations = @user.associations(:order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # DELETE /backend/association.html -------------------------------- HTML
  def destroy
    Association.delete(params[:id])
    respond_success "Ассоциация успешно удалена"  
  rescue
    respond_error
  end
  
private
  
  def init_org
    @org = Org.find(params[:id])
  end
end
