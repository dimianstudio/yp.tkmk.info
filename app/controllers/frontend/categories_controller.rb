class Frontend::CategoriesController < FrontendController
  
  # Caching show action as page
  caches_page :show
  
  # GET /categories/1.html ---------------------------------------- HTML  
  # GET /categories/1.js ------------------------------------------ AJAX
  # GET /categories/1/page/1.html --------------------------------- HTML
  def show
    @current_category = Category.find(params[:id])
    respond_to do |format|
      format.html { 
        @orgs = @current_category.orgs.paginate(:page => params[:page], :per_page => 10, :order => "recommended DESC", :include => [:town,:street, :rewiews]) 
      }
      format.js {
        @categories = @current_category.children
        render :partial => 'categories', 
               :layout => false, 
               :locals => {:categories => @categories, :categories_size => Category.count_parent_categories-1, :category_id => params[:id]}
      }
    end
  end
end
