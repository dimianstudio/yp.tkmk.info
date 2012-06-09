class Backend::CategoriesController < BackendController
    
  # Filters
  before_filter :init_category, :only => [:show, :edit, :update, :restructure]
  
  # Sweepers
  cache_sweeper :category_sweeper, :only => [:create, :update, :restructure, :destroy]
  
  # GET /backend/categories.html ------------------------------------ HTML
  def index
  end
  
  # GET /backend/categories/1.html ---------------------------------- HTML
  # GET /backend/categories/1.js ------------------------------------ AJAX
  def show
    respond_to do |format|
      format.html { 
        @orgs = @category.orgs.paginate(:page => params[:page], :per_page => 10)
      }
      format.js {
        @categories = @category.children
        render :partial => 'show', :layout => false, :locals => {:categories => @categories, :category_id => params[:id]}
      }
    end
  end
  
  # POST /backend/categories.html ----------------------------------- HTML
  def create
    category = Category.new
    category.name = params[:category][:name]
    category.parent_id = params[:category][:parent_id].to_i
    category.save!
    output_success "Категория успешно создана"   
  rescue
    output_failure
  end
  
  # GET /backend/categories/1/edit.html ----------------------------- HTML
  def edit 
    session[:back] = request.env["HTTP_REFERER"]    
  end
  
  # PUT /backend/categories/1.html ---------------------------------- HTML
  def update
    @category.name = params[:category][:name]
    @category.parent_id = params[:category][:parent_id]
    @category.save!
    output_success "Категория успешно отредактированна", session[:back]  
  rescue
    output_failure  
  end  
  
  # POST /backend/categories/restructure?category_id=1&format=js ----- AJAX
  def restructure
    @category.parent_id = params[:category_id]
    @category.save!
    output_success("Категория успешно перемещена", params[:id])    
  rescue
    output_failure
  end
  
  # DELETE /backend/categories/1.html ------------------------------ HTML
  def destroy
    Category.delete(params[:id])
    output_success "Категория успешно удалена"
  rescue
    output_failure
  end
  
  private
  
  def init_category
    @category = Category.find(params[:id])
  end
  
  def output_success(msg, id = 0)
    respond_to do |format|
      format.html { 
        flash[:notice] = msg
        redirect_to backend_categories_url 
      }
      format.js { render :partial => 'success', :layout => false , :locals => {:id => id}}
    end
  end
  
  def output_failure(msg = "Извините, произошла ошибка!!!")
    respond_to do |format|
      format.html { 
        flash[:error] = msg
        redirect_to backend_categories_url 
      }
      format.js { render :partial => 'error', :layout => false }
    end
  end
end