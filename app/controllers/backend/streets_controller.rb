class Backend::StreetsController < BackendController
  
  # Filters
  before_filter :init_street, :only => [:edit, :update, :show]
  
  # Sweepers
  cache_sweeper :street_sweeper, :only => [:create, :update, :destroy]
  
  # GET /backend/streets.html --------------------------------------- HTML 
  def index
    @streets = Street.find(:all, :order => "name ASC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/streets/1.html ------------------------------------- HTML
  def show
    @orgs = @street.orgs.paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/streets.html -------------------------------------- HTML
  def create
    street      = Street.new
    street.name = params[:street][:name]
    street.save!
    respond_success "Улица успешно добавлена"   
  rescue
    respond_error
  end
  
  # GET /backend/streets/1/edit.html -------------------------------- HTML
  def edit
    session[:back] = request.env["HTTP_REFERER"]  
  end
  
  # PUT /backend/streets/1.html ------------------------------------- HTML
  def update
    @street.name = params[:street][:name]
    @street.save!
    respond_success "Улица успешно отредактирована", session[:back] 
  rescue
    respond_error
  end
  
  # DELETE /backend/streets/1.html ---------------------------------- HTML
  def destroy
    Street.delete(params[:id])
    respond_success "Улица успешно удалена"   
  rescue
    respond_error
  end
  
private

  def init_street
    @street = Street.find(params[:id])
  end
end