class BackendController < ApplicationController
  
  # TODO: запрет гостям и пользователям вообще видеть любую страницу при запросе к админке просто выдавать 404 страницу
  
  layout "backend/index" 
  
  # Include libs
  include ExpireCache

  # Access only admin
  require_role "admin"
  
  alias_method :base_redirect_to, :redirect_to
  
  def redirect_to(options = {}, response_status = {})
    session[:back] = nil
    base_redirect_to options    
  end  
  
  def respond_success(msg, return_url = :back)
    flash[:notice] = msg
    redirect_to return_url
  end
  
  def respond_error(msg = "Извините, произошла ошибка!!!", return_url = :back)
    flash[:error] = msg
    redirect_to return_url
  end

end