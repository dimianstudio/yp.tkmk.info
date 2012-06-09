class Backend::IndexController < BackendController

  # GET /backend.html ----------------------------------------------- HTML
  def index    
    # @data = ga_get_data
    # @users = User.find(:all, :order => "created_at DESC", :limit => 5)
    # @rewiews = Rewiew.find(:all, :order => "created_at DESC", :limit => 5)
    # @requests = Request.find(:all, :order => "created_at DESC", :limit => 5)
  end 
  
private
 
  def ga_get_data
    Garb::Session.login('tokmakcity@gmail.com', 'dimian17041987')
    profile = Garb::Profile.first('UA-17022263-3')
    report = Garb::Report.new(profile, :start_date => (Date.today - 15), :end_date => Date.today)
    report.metrics :visits, :pageviews
    report.dimensions :date
    report.results
  end
end
