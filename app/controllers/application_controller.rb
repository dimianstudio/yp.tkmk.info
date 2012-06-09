# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # rescue_from Exception,                            :with => :render_404
  # rescue_from ActiveRecord::RecordNotFound,         :with => :render_404
  # rescue_from ActionController::RoutingError,       :with => :render_404
  # rescue_from ActionController::UnknownController,  :with => :render_404
  # rescue_from ActionController::UnknownAction,      :with => :render_404
  
  include CacheableFlash
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def default_url_options(options = { :value => true })
    { :format => "html" }
  end
  
  def render_optional_error_file(status)
    render_404
  end
  
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to new_session_path
      end
      format.js do
        render :inline => 'error'
      end
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # Add any other API formats here.  (Some browsers, notably IE6, send Accept: */* and trigger 
      # the 'format.any' block incorrectly. See http://bit.ly/ie6_borken or http://bit.ly/ie6_borken2
      # for a workaround.)
      format.any(:json, :xml) do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  private

  def render_404
    render :file => "#{RAILS_ROOT}/public/404.html",:status => 404 
  end
end