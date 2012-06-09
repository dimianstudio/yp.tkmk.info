require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::ProfileController do

  describe "routing" do
    
    # settings_profile GET    /profile/settings(.:format)                         {:controller=>"frontend/profile", :action=>"settings"}
    #    profile_index GET    /profile(.:format)                                  {:controller=>"frontend/profile", :action=>"index"}    
    
    it "should generate params { :controller => 'frontend/profile', action => 'index', format => 'html' } from GET /profile.html" do
      params_from(:get, "/profile.html").should == {:controller => "frontend/profile", :action => "index", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/profile', action => 'settings', format => 'html' } from GET /profile/settings.html" do
      params_from(:get, "/profile/settings.html").should == {:controller => "frontend/profile", :action => "settings", :format => "html"}
    end   
  end
  
  describe "GET /profile.html" do
    
    def do_index
      get :index, :format => "html"
    end
    
    it "should render template index.html.haml if the user has rights" do
      user_has_rights
      
      do_index
      response.should render_template("index.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_index
      response.should redirect_to new_session_url
    end
  end
  
  describe "GET /settings.html" do
    
    def do_settings
      get :settings, :format => "html"
    end
    
    it "should render template settigns.html.haml if the user has rights" do
      user_has_rights
      
      do_settings
      response.should render_template("settings.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_settings
      response.should redirect_to new_session_url
    end
  end
end
