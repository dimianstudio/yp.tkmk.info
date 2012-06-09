class Backend::ImagesController < BackendController
  
  # Filters
  before_filter :init_org

  # GET /backend/orgs/1/images.html --------------------------------- HTML
  def index    
  end
  
  # GET /backend/orgs/1/images.html --------------------------------- HTML
  def show    
  end

private

  def init_org
    @org = Org.find(params[:id])
  end
end