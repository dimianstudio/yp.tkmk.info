class Backend::UsersController < BackendController

  # Filters and sweepers
  before_filter :init_user, :only => [:update, :show, :rewiews, :orgs, :requests, :rights, :add_right]
  
  # GET /backend/users.html ----------------------------------------- HTML
  def index
    @users = User.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/users/1.html --------------------------------------- HTML
  def show 
  end
  
  # PUT /backend/users/1.html --------------------------------------- HTML
  def update  
    user = User.find(params[:id])
    unless params[:user][:password].blank?
      if params[:user][:password] == params[:user][:password_confirmation]
        user.update_attributes!(params[:user])
        respond_success "Ваши изменения успешно сохранены"
      else
        respond_error "Пароли не совпадают"
      end
    else
      user.update_attributes!(:name => params[:user][:name], :email => params[:user][:email])
      respond_success "Ваши изменения успешно сохранены"
    end
  end
  
  # GET /backend/users/1/rights.html -------------------------------- HTML
  def rights
    @rights = @user.rights.paginate(:page => params[:page], :per_page => 10)
  end
  
  # POST /backend/users/1/add_right.html ---------------------------- HTML
  def add_right
    @rights = @user.rights.collect{ |r| r.role_id }.to_a
    unless @rights.include?(params[:right][:id].to_i)
      @right = Right.create!( :role_id => params[:right][:id].to_i)
      @user.rights << @right
      @user.save!
      respond_success "Роль успешно присвоена"
    else
      respond_success "Роль успешно присвоена"
    end
  rescue
    respond_error
  end
  
  # DELETE /backend/users/1/delete_right/1.html --------------------- HTML
  def delete_right
    Right.destroy(params[:right_id])
    respond_success "Роль успешно удалена"     
  rescue
    respond_error
  end
  
  # GET /backend/users/1/orgs.html ---------------------------------- HTML
  def orgs
    @orgs = @user.orgs.paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/users/1/requests.html ------------------------------ HTML
  def requests
    @requests = @user.requests.paginate(:page => params[:page], :per_page => 10)
  end  
  
  # GET /backend/users/1/rewiews.html ------------------------------- HTML
  def rewiews
    @rewiews = @user.rewiews.paginate(:page => params[:page], :per_page => 5)
  end  

private
  
  def init_user
    @user = User.find(params[:id])
  end
end
