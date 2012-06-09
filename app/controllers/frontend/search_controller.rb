class Frontend::SearchController < FrontendController
  
  auto_complete_for :tag, :name, :query
  
  def index
    unless params[:query].blank?
      @results = Org.search params[:query], :page => params[:page], :per_page => 10
    else
      respond_error "Введите что нибудь", root_path
    end
  end  
end
