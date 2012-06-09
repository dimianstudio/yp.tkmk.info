require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::ServiceController do

  describe "routing" do
    
    #             help        /help(.:format)                                     {:controller=>"frontend/service", :action=>"help"}
    #      advertising        /advertising(.:format)                              {:controller=>"frontend/service", :action=>"advertising"}
    #       contact_us        /contact_us(.:format)                               {:controller=>"frontend/service", :action=>"contact_us"}
    # emergency_phones        /emergency_phones(.:format)                         {:controller=>"frontend/service", :action=>"emergency_phones"}
    #      help_phones        /help_phones(.:format)                              {:controller=>"frontend/service", :action=>"help_phones"}
    
    it "should generate params { :controller => 'frontend/service', action => 'help', format => 'html' } from GET /help.html" do
      params_from(:get, "/help.html").should == {:controller => "frontend/service", :action => "help", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/service', action => 'advertising', format => 'html' } from GET /advertising.html" do
      params_from(:get, "/advertising.html").should == {:controller => "frontend/service", :action => "advertising", :format => "html"}
    end  
    
    it "should generate params { :controller => 'frontend/service', action => 'contact_us', format => 'html' } from GET /contact_us.html" do
      params_from(:get, "/contact_us.html").should == {:controller => "frontend/service", :action => "contact_us", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/service', action => 'emergency_phones', format => 'html' } from GET /emergency_phones.html" do
      params_from(:get, "/emergency_phones.html").should == {:controller => "frontend/service", :action => "emergency_phones", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/service', action => 'help_phones', format => 'html' } from GET /help_phones.html" do
      params_from(:get, "/help_phones.html").should == {:controller => "frontend/service", :action => "help_phones", :format => "html"}
    end
  end
  
  describe "GET /help.html" do
    it "should render template help.html.haml" do
      get :help, :format => "html"
      response.should render_template("help.html.haml")
    end
  end
  
  describe "GET /advertising.html" do
    it "should render template advertising.html.haml" do
      get :advertising, :format => "html"
      response.should render_template("advertising.html.haml")
    end
  end
  
  describe "GET /contact_us.html" do
    it "should render template contact_us.html.haml" do
      get :contact_us, :format => "html"
      response.should render_template("contact_us.html.haml")
    end
  end
  
  describe "GET /emergency_phones.html" do
    it "should render template emergency_phones.html.haml" do
      get :emergency_phones, :format => "html"
      response.should render_template("emergency_phones.html.haml")
    end
  end
  
  describe "GET /help_phones.html" do
    it "should render template help_phones.html.haml" do
      get :help_phones, :format => "html"
      response.should render_template("help_phones.html.haml")
    end
  end
end
