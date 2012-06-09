class Backend::TownsController < BackendController

  # Filters
  before_filter :init_town, :only => [:edit, :update, :show]
  
  # Sweepers
  cache_sweeper :town_sweeper, :only => [:create, :update, :destroy]
  
  # GET /backend/towns.html ----------------------------------------- HTML
  def index
    @towns = Town.find(:all, :order => "name ASC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/towns/1.html --------------------------------------- HTML
  def show
    @orgs = @town.orgs.paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/towns.html ---------------------------------------- HTML
  def create
    town = Town.new
    town.name = params[:town][:name]
    town.save!
    respond_success "Населенный пункт успешно добавлен"   
  rescue
    respond_error
  end 
  
  # GET /backend/towns/1/edit.html ---------------------------------- HTML
  def edit
    session[:back] = request.env["HTTP_REFERER"]  
  end 
  
  #  PUT /backend/towns/1.html -------------------------------------- HTML
  def update
    @town.name = params[:town][:name]
    @town.save!
    respond_success "Населенный пункт успешно отредактирован", session[:back]   
  rescue
    respond_error
  end
  
  # DELETE /backend/towns/1.html ------------------------------------ HTML
  def destroy
    Town.delete(params[:id])
    respond_success "Населенный пункт успешно удален"    
  rescue
    respond_error
  end
  
private

  def init_town
    @town = Town.find(params[:id])
  end
end