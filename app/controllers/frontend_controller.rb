class FrontendController < ApplicationController
  
  layout "frontend/index"
  
private

  def respond_success(msg, return_url = :back)
    flash[:notice] = msg
    redirect_to return_url
  end
  
  def respond_error(msg = "Извините, произошла ошибка!!!", return_url = :back)
    flash[:error] = msg
    redirect_to return_url
  end
  
  def init_session_variable
    session[:back] ||= request.env["HTTP_REFERER"]
  end  
end