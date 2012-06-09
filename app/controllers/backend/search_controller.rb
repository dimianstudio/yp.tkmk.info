class Backend::SearchController < BackendController
    
  def index
    @results = Org.search params[:query], :page => params[:page], :per_page => 10, :match_mode => :boolean
  end
end
