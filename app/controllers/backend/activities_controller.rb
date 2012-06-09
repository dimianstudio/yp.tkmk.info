class Backend::ActivitiesController < BackendController

  # Filters
  before_filter :init_org

  # GET /backend/orgs/1/activities.html ----------------------------- HTML
  def index
    @activities = @org.activities.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/orgs/1/activities.html ---------------------------- HTML
  def create
    params[:activities].each do |activity|
      activity = @org.activities.build(:category_id => activity)
      activity.save!
    end 
    expire_cache(params[:org_id]) 
    respond_success "Вид деятельности успешно добавлен"     
  rescue
    respond_error
  end
  
  # DELETE /backend/orgs/1/activities/1.html ------------------------ HTML
  def destroy
    expire_cache(params[:org_id]) 
    Activity.delete(params[:id])
    respond_success "Вид деятельности успешно удален"    
  rescue
    respond_error
  end
  
private

  def init_org
    @org = Org.find(params[:org_id])
  end
  
  def expire_cache(id)
    org = Org.find(id)
    expire_file("orgs/#{id}.html")
    expire_file("orgs/#{id}/activities.html")
    org.categories.collect{ |c| [c.id] }.each do |category|
      expire_files("categories/#{category}.html") 
      expire_dirs("categories/#{category}/")
    end
  end
end