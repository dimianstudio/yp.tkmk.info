class Backend::MapsController < BackendController
  
  # Filters
  before_filter :init_org
  
  # GET /backend/orgs/1/maps.html ----------------------------------- HTML
  def index    
  end
  
private

  def init_org
    @org = Org.find(params[:org_id])
  end
  
end
