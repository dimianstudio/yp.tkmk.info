class Backend::TagsController < BackendController
  
  # Filters
  before_filter :init_tag, :only => [:edit, :update, :show]
  
  # Sweepers
  cache_sweeper :tag_sweeper, :only => [:create, :update, :destroy]
  
  # GET /backend/tags.html ------------------------------------------ HTML
  def index
    @tags = Tag.find(:all, :order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/tags/1.html ---------------------------------------- HTML
  def show
    @orgs = @tag.orgs.paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/tags.html ----------------------------------------- HTML
  def create
    raise Tag::NoRequiredFields if params[:tag][:string].blank?
    tags = params[:tag][:string].downcase.split(",").reject(&:blank?).map(&:strip).uniq
    user = current_user.id    
    Tag.transaction do
      tags.each do |tag|      
        Tag.find_or_add(tag, user)
      end      
    end
    respond_success "Тэг(-и) успешно добавлен(-ы)"    
  rescue Tag::NoRequiredFields => e
    respond_error e.message
  end
  
  # GET /backend/tags/1/edit.html ----------------------------------- HTML
  def edit  
    session[:back] = request.env['HTTP_REFERER'] 
  end  
  
  # PUT /backend/tags/1.html ---------------------------------------- HTML
  def update
    @tag.name = params[:tag][:name]
    @tag.save!
    respond_success "Тэг успешно отредактирован", session[:back]   
  rescue
    respond_error  
  end
  
  # GET /backend/tags/1/user.html ----------------------------------- HTML
  def user
    @user = User.find(params[:id])
    @tags = @user.tags(:order => 'created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end
  
  # DELETE /backend/tags/1.html ------------------------------------- HTML
  def destroy
    Tag.destroy(params[:id])
    respond_success "Тэг успешно удален" 
  rescue
    respond_error
  end
  
private

  def init_tag
    @tag = Tag.find(params[:id])
  end
end