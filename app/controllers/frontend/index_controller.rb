class Frontend::IndexController < FrontendController
  
  # Caching index action as page
  caches_page :index
  
  # GET / ----------------------------------------------------------- HTML
  def index
  end  
end