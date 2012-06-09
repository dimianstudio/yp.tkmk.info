class Frontend::SessionsController < FrontendController
  require "#{RAILS_ROOT}/app/models/user.rb"
  
  # GET /login.html ------------------------------------------------- HTML
  def new
  end
  
  # POST /session.html ---------------------------------------------- HTML
  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  # GET /logout.html ---------------------------------------------------- HTML
  def destroy
    logout_killing_session!
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Проверьте правильность имени и пароля"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
