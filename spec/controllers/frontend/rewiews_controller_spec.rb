require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::RewiewsController do

  describe "routing" do    
    
    #        org_rewiews GET    /orgs/:org_id/rewiews(.:format)                     {:controller=>"frontend/rewiews", :action=>"index"}
    #    rewiew_paginate GET    /orgs/:org_id/rewiews/page/:page(.:format)          {:controller=>"frontend/rewiews", :action=>"index"}
    #                    POST   /orgs/:org_id/rewiews(.:format)                     {:controller=>"frontend/rewiews", :action=>"create"}
    # create_org_rewiews POST   /orgs/:org_id/rewiews/create(.:format)              {:controller=>"frontend/rewiews", :action=>"create"} /for passenger/
    
    it "should generate params { :controller => 'frontend/rewiews', action => 'index', org_id => 1, format => 'html' } from GET /orgs/1/rewiews.html" do
      params_from(:get, "/orgs/1/rewiews.html").should == {:controller => "frontend/rewiews", :action => "index", :org_id => "1", :format => "html"}
    end

    it "should generate params { :controller => 'frontend/rewiews', action => 'index', org_id => 1, page => 1, format => 'html' } from GET /orgs/1/rewiews/page/1.html" do
     params_from(:get, "/orgs/1/rewiews/page/1.html").should == {:controller => "frontend/rewiews", :action => "index", :org_id => "1", :page => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/rewiews', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/rewiews.html" do
      params_from(:post, "/orgs/1/rewiews.html").should == {:controller => "frontend/rewiews", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/rewiews', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/rewiews/create.html" do
      params_from(:post, "/orgs/1/rewiews/create.html").should == {:controller => "frontend/rewiews", :action => "create", :org_id => "1", :format => "html"}
    end
  end
  
  describe "GET /orgs/1/rewiews.html" do
    
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_index
      get :index, {:org_id => 1, :format => "html"}
    end
    
    it "should render template index.html.haml, assign variable @rewiews and caching page" do
      @rewiews = []
      (1..5).each do |i| @rewiews << mock_model(Rewiew, :id => i, :text => "Комментарий#{i}", :org_id => 1, :user_id => 1+i ) end        
      @org.stub(:rewiews).and_return(@rewiews)
      
      do_index
      assigns[:org].should == @org
      assigns[:rewiews].should == @rewiews
      response.should render_template("index.html.haml") 
      lambda { get :index, {:org_id => 1, :format => "html"} }.should cache_page('/orgs/1/rewiews.html')
    end
    
    it "should render the 404 page if the org not found" do
      Org.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)

      do_index
    end
  end
  
  describe "POST /orgs/1/rewiews.html" do
    
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_create
      post :create, {:org_id => 1, :rewiew => { :text => "Комментарий" }, :format => "html"}
    end
    
    it "should redirect to :back with success flash-message if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      Rewiew.stub(:add!).and_return(nil)
      
      do_create
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо за отзыв!!!")
      response.should redirect_to org_rewiews_path :org_id => 1        
    end
    
    it "should redirect to :back with error flash-message if the text is blank" do
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      
      post :create, {:org_id => 1, :rewiew => { :text => "" }, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует написать хоть какие-то слова ;)")
      response.should redirect_to org_rewiews_path :org_id => 1        
    end
    
    it "should redirect to :back with error flash-message if the text isn't defined" do
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      
      post :create, {:org_id => 1, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует написать хоть какие-то слова ;)")
      response.should redirect_to org_rewiews_path :org_id => 1        
    end
    
    it "should redirect to :back with error flash-message if a user is engaged spam" do
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      Rewiew.stub(:add!).and_raise(Rewiew::RecordExist)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Вы уже оставляли такой отзыв")
      response.should redirect_to org_rewiews_path :org_id => 1        
    end
    
    it "should redirect to :back with error flash-message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      Rewiew.stub(:add!).and_raise(ActiveRecord::RecordNotSaved)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_rewiews_path :org_id => 1   
    end
    
    it "should redirect to :back with error flash-message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_rewiews_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Rewiew.stub(:add!).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_rewiews_path :org_id => 1  
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_create
      response.should redirect_to new_session_url
    end
  end
  
  describe "POST /orgs/1/rewiews.js" do
    
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_create
      post :create, {:org_id => 1, :rewiew => { :text => "Комментарий" }, :format => "js"} 
    end
    
    it "should show success flash-message if the user has rights and the params is valid" do
      user_has_rights
      @rewiew = Rewiew.new( :text => "Комментарий", :org_id => 1, :user_id => 1 )
      Rewiew.stub(:add!).and_return(@rewiew)
      controller.should_receive(:render).with(:partial => 'success', :layout => false, :locals => {:rewiew => @rewiew, :msg => "Спасибо за отзыв!!!"})
      
      do_create      
    end
    
    it "should show error flash-message if the text is blank" do
      user_has_rights
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Следует написать хоть какие-то слова ;)"})
      
      post :create, {:org_id => 1, :rewiew => { :text => "" }, :format => "js"}        
    end
    
    it "should show error flash-message if the text isn't defined" do
      user_has_rights
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Следует написать хоть какие-то слова ;)"})
      
      post :create, {:org_id => 1, :format => "js"}  
    end
    
    it "should show error flash-message if a user is engaged spam" do
      user_has_rights
      Rewiew.stub(:add!).and_raise(Rewiew::RecordExist)
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Вы уже оставляли такой отзыв"})
      
      do_create
    end
    
    it "should redirect to :back with error flash-message if throw ActiveRecord::RecordNotSaved exception" do      
      user_has_rights
      Rewiew.stub(:add!).and_raise(ActiveRecord::RecordNotSaved)
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Извините, произошла ошибка!!!"})
    
      do_create 
    end
    
    it "should redirect to :back with error flash-message if throw ActiveRecord::RecordInvalid exception" do      
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Rewiew.stub(:add!).and_raise(ActiveRecord::RecordInvalid.new(model))
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Извините, произошла ошибка!!!"})
    
      do_create
    end
    
    it "should render text 'error' if the user doesn't have rights" do 
      controller.should_receive(:render).with(:inline => 'error')      
           
      do_create
    end
  end
end
