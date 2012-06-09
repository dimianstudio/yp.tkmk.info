require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::RequestsController do

  describe "routing" do
    it "should generate params { :controller => 'frontend/requests', action => 'index', format => 'html' } from GET /profile/requests.html" do
      params_from(:get, "/profile/requests.html").should == {:controller => "frontend/requests", :action => "index", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/requests', action => 'index', org_id => 1, page => 1, format => 'html' } from GET /profile/requests/page/1.html" do
     params_from(:get, "/profile/requests/page/1.html").should == {:controller => "frontend/requests", :action => "index", :page => "1", :format => "html"}
    end   
  end
  
  describe "GET /profile/requests.html" do
    
    def do_index
      get :index, :format => "html"
    end
    
    it "should render template index.html.haml if the user has rights" do
      user_has_rights
      requests = []
      5.times do |i| requests << mock_model(Request, :id => i, :user_id => 1+i, :org_id => i+1, :object => "org", :action => "edit", :content => "Данные#{i}") end        
      Request.stub(:find).and_return(requests)
      
      do_index
      assigns[:requests].should == requests
      response.should render_template("index.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_index   
      response.should redirect_to new_session_url
    end
  end

end
