class Helper
  include Singleton
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
end

class Frontend::UsersController < FrontendController
  
  require_role ["admin", "user"], :only => :update

  # GET /signup.html ------------------------------------------------ HTML
  def new
    @user = User.new
  end
  
  # POST /users.html ------------------------------------------------ HTML
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      
      # TODO: явно указать что нужно присвоить 2
      
      # Add rights
      @right = Right.new
      @right.role_id = 1
      @user.rights << @right
      @user.save!
      
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      flash[:notice] = "Спасибо за регистрацию!!!"
      redirect_back_or_default('/')      
    else      
      flash[:error]  = "Извините произошла ошибка, попробуйте повторить регистрацию, в случае неудачи свяжитесь с #{mail_helper.mail_to APP_CONFIG['admin_email'], "администрацией", :encode => "hex"}"
      render :action => 'new'
    end
  end
  
  def update
    if current_user.id == params[:id].to_i
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
    else
      respond_error
    end
  end
  
  private
  
  def mail_helper
    Helper.instance
  end
end
