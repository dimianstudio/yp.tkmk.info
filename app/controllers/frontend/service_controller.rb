class Frontend::ServiceController < FrontendController
  
  # Caching pages
  caches_page :help, :terms, :advertising, :contact_us, :emergency_phones, :help_phones
  
  # GET /help.html -------------------------------------------------- HTML
  def help    
  end
  
  # GET /advertising.html ------------------------------------------- HTML
  def advertising    
  end
  
  # GET /contact_us.html -------------------------------------------- HTML
  def contact_us    
  end
  
  # GET /emergency_phones.html -------------------------------------- HTML
  def emergency_phones    
  end
  
  # GET /help_phones.html ------------------------------------------- HTML
  def help_phones    
  end
  
  # GET /terms.html ------------------------------------------- HTML
  def terms    
  end
end
