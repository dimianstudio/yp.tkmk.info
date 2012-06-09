require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::ActivitiesController do
  
  describe "routing" do
    
    #        org_activities GET    /orgs/:org_id/activities(.:format)                  {:controller=>"frontend/activities", :action=>"index"}
    #                       POST   /orgs/:org_id/activities(.:format)                  {:controller=>"frontend/activities", :action=>"create"}
    # create_org_activities POST   /orgs/:org_id/activities/create(.:format)           {:controller=>"frontend/activities", :action=>"create"} /for passenger/   
    #          org_activity DELETE /orgs/:org_id/activities/:id(.:format)              {:controller=>"frontend/activities", :action=>"destroy"}
    #   delete_org_activity DELETE /orgs/:org_id/activities/:id/delete(.:format)       {:controller=>"frontend/activities", :action=>"delete"}
    
    it "should generate params { :controller => 'frontend/activities', action => 'index', org_id => 1, format => 'html' } from GET /orgs/1/activities.html" do
      params_from(:get, "/orgs/1/activities.html").should == {:controller => "frontend/activities", :action => "index", :org_id => "1", :format => "html"}
    end  
    
    it "should generate params { :controller => 'frontend/activities', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/activities.html" do
      params_from(:post, "/orgs/1/activities.html").should == {:controller => "frontend/activities", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/activities', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/activities/create.html" do
      params_from(:post, "/orgs/1/activities/create.html").should == {:controller => "frontend/activities", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/activities', action => 'destroy', org_id => 1, id => 1, format => 'html' } from DELETE /orgs/1/activities/1.html" do
      params_from(:delete, "/orgs/1/activities/1.html").should == {:controller => "frontend/activities", :action => "destroy", :org_id => "1", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/activities', action => 'delete', org_id => 1, id => 1, format => 'html' } from DELETE /orgs/1/activities/1/delete.html" do
      params_from(:delete, "/orgs/1/activities/1/delete.html").should == {:controller => "frontend/activities", :action => "delete", :org_id => "1", :id => "1", :format => "html"}
    end
  end
  
  describe "GET /orgs/1/activities.html" do
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    end
   
    def do_index
      get :index, {:org_id => 1, :format => "html"}
    end
    
    it "should render template index.html.haml, assign variable :org and :categories and caching page" do
      @categories = []
      (1..5).each do |i| @categories << mock_model(Category, :id => i, :parent_id => 2, :name => "Категория #{i}" ) end        
      Org.stub(:find).and_return(@org)
      @org.stub(:categories).and_return(@categories)
      
      do_index
      assigns[:org].should == @org
      assigns[:categories].should == @categories
      response.should render_template("index.html.haml")
      lambda { get :index, {:org_id => 1, :format => "html"} }.should cache_page('/orgs/1/activities.html')
    end
    
    it "should render the 404 page if the org not found" do
      Org.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)

      do_index
    end
  end
  
  describe "POST /orgs/1/activities/create.html" do    
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
    end
    
    def do_create
      post :create, {:org_id => 1, :activities => ["1", "2"], :format => "html"}
    end
    
    it "should redirect to request_path with success flash if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_create
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_activities_path(:org_id => 1)
      response.should redirect_to requests_path       
    end
    
    it "should redirect to org_activities_path with error flash if the user has rights admin or user and the params isn't valid" do
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      
      post :create, {:org_id => 1, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to org_activities_path :org_id => 1        
    end
    
    it "should redirect to :back with error flash if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
    
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_activities_path :org_id => 1
    end
        
    it "should redirect to :back with error flash if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
    
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_activities_path :org_id => 1
    end
    
    it "should redirect to login page if the user doesn't have rights" do
      do_create
      response.should redirect_to new_session_url
    end        
  end
  
  describe "DELETE /orgs/1/activities/1.html" do
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_destroy
      delete :destroy, {:org_id => 1, :id => 1, :format => "html"}
    end
    
    it "should render template destroy.html.haml and assign variables - :org, :activity" do
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      category = mock_model(Category, :id => 3, :parent_id => 2, :name => "Категория" )      
      Activity.stub(:get).and_return(category)
      
      do_destroy
      assigns[:org].should == @org
      assigns[:activity].should == org_activities_path(:org_id => 1)
      response.should render_template("destroy.html.haml")    
    end
    
    it "should redirect to org_activities_path with error flash if throw Activity::RecordNotFound exception" do
      user_has_rights   
      Activity.stub(:get).and_raise(Activity::RecordNotFound)
      
      do_destroy
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Такого вида деятельности нет")
      response.should redirect_to org_activities_path :org_id => 1  
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_destroy
      response.should redirect_to new_session_url
    end
  end
  
  describe "DELETE /orgs/1/activities/1/delete.html" do    
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
    end
    
    def do_delete
      delete :delete, {:org_id => 1, :id => 1, :request => { :msg => "Причина"}, :format => "html"}
    end
    
    it "should redirect to request_path with success flash if the user has rights admin or user and the params is valid" do
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_delete
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_activities_path(:org_id => 1)
      response.should redirect_to requests_path      
    end
    
    it "should redirect to org_activities_url with error flash if the user has rights admin or user and the params isn't valid" do
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      delete :delete, {:org_id => 1, :id => 1, :request => { :msg => "" }, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to org_activities_path :org_id => 1        
    end
    
    it "should redirect to org_activities_path with error flash if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
    
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_activities_path :org_id => 1
    end
        
    it "should redirect to org_activities_path with error flash if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_activities_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
    
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_activities_path :org_id => 1
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_delete
      response.should redirect_to new_session_url
    end        
  end  
end