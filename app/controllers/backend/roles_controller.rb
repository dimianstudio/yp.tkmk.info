class Backend::RolesController < BackendController
  
  # Filters
  before_filter :init_role, :only => [:show, :edit, :update]

  # GET /backend/roles.html ----------------------------------------- HTML
  def index
    @roles = Role.find(:all, :order => "name ASC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/roles/1.html --------------------------------------- HTML
  def show
    @users = @role.users.paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/roles.html ---------------------------------------- HTML
  def create
    role = Role.new
    role.name = params[:role][:name]
    role.save!
    respond_success "Роль успешно создана"  
  rescue
    respond_error
  end
  
  # GET /backend/roles/1/edit.html ---------------------------------- HTML
  def edit 
    session[:back] = request.env['HTTP_REFERER']    
  end
  
  # PUT /backend/roles/1.html --------------------------------------- HTML
  def update
    @role.name = params[:role][:name]
    @role.save!
    respond_success "Роль успешно отредактированна", session[:back]   
  rescue
    respond_error
  end
  
  # DELETE /backend/roles/1.html ------------------------------------ HTML
  def destroy
    Role.delete(params[:id])
    respond_success "Роль успешно удалена"
  rescue
    respond_error
  end
  
private

  def init_role
    @role = Role.find(params[:id])
  end
end
