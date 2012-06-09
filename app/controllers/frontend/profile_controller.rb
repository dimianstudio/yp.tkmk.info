class Frontend::ProfileController < FrontendController
  
  # Access 
  # - admin and user  :index, :settings
  require_role ["admin", "user"]
  
  # GET /profile.html ----------------------------------------------- HTML
  def index    
  end
  
  # GET /profile/settings.html -------------------------------------- HTML
  def settings 
  end
end
