require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::PhonesController do

  describe "routing" do
    
    #        org_phones GET    /orgs/:org_id/phones(.:format)                      {:controller=>"frontend/phones", :action=>"index"}      
    #                   POST   /orgs/:org_id/phones(.:format)                      {:controller=>"frontend/phones", :action=>"create"}
    # create_org_phones POST   /orgs/:org_id/phones/create(.:format)               {:controller=>"frontend/phones", :action=>"create"} /for passenger/
    #    edit_org_phone GET    /orgs/:org_id/phones/:id/edit(.:format)             {:controller=>"frontend/phones", :action=>"edit"}
    #         org_phone PUT    /orgs/:org_id/phones/:id(.:format)                  {:controller=>"frontend/phones", :action=>"update"}    
    #                   DELETE /orgs/:org_id/phones/:id(.:format)                  {:controller=>"frontend/phones", :action=>"destroy"}
    #  delete_org_phone DELETE /orgs/:org_id/phones/:id/delete(.:format)           {:controller=>"frontend/phones", :action=>"delete"}
    
    it "should generate params { :controller => 'frontend/phones', action => 'index', org_id => 1, format => 'html' } from GET /orgs/1/phones.html" do
      params_from(:get, "/orgs/1/phones.html").should == {:controller => "frontend/phones", :action => "index", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/phones.html" do
      params_from(:post, "/orgs/1/phones.html").should == {:controller => "frontend/phones", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/phones/create.html" do
      params_from(:post, "/orgs/1/phones/create.html").should == {:controller => "frontend/phones", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'edit', org_id => 1, id => 1, format => 'html' } from GET /orgs/1/phones/1/edit.html" do
      params_from(:get, "/orgs/1/phones/1/edit.html").should == {:controller => "frontend/phones", :action => "edit", :org_id => "1", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'update', org_id => 1, id => 1, format => 'html' } from PUT /orgs/1/phones/1.html" do
     params_from(:put, "/orgs/1/phones/1.html").should == {:controller => "frontend/phones", :action => "update", :org_id => "1", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'destroy', org_id => 1, id => 1, format => 'html' } from DELETE /orgs/1/phones/1.html" do
     params_from(:delete, "/orgs/1/phones/1.html").should == {:controller => "frontend/phones", :action => "destroy", :org_id => "1", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/phones', action => 'delete', org_id => 1, id => 1, format => 'html' } from DELETE /orgs/1/phones/1/delete.html" do
     params_from(:delete, "/orgs/1/phones/1/delete.html").should == {:controller => "frontend/phones", :action => "delete", :org_id => "1", :id => "1", :format => "html"}
    end 
    
    it "should generate params { :controller => 'frontend/phones', action => 'index', org_id => 1, page => 1, format => 'html' } from GET /orgs/1/phones/page/1.html" do
     params_from(:get, "/orgs/1/phones/page/1.html").should == {:controller => "frontend/phones", :action => "index", :org_id => "1", :page => "1", :format => "html"}
    end   
  end

  describe "GET /orgs/1/phones.html" do  
    def do_index
      get :index, {:org_id => 1, :format => "html"}
    end
    
    it "should render template index.html.haml, assign variable @phones and caching page" do
      org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(org)
      phones = [mock_model(Phone, :id => 20, :org_id => 1, :department => "Отдел", :number => "11111")]
      org.stub(:phones).and_return(phones)
      
      do_index
      assigns[:org].should == org
      assigns[:phones].should == phones
      response.should render_template("index.html.haml")    
      lambda { do_index }.should cache_page('/orgs/1/phones.html')
    end
    
    it "should render the 404 page if the org not found" do
      Org.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)

      do_index
    end
  end
  
  describe "POST /orgs/1/phones/create.html" do
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
    end
    
    def do_create
      post :create, {:org_id => 1, :phone => { :department => "Отдел", :number => "11111"}, :format => "html"}
    end
    
    it "should redirect to requests_path with success flash-message if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_create
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_phones_path(:org_id => 1)
      response.should redirect_to requests_path      
    end
    
    it "should redirect to :back with error flash-message if the  params isn't valid" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      post :create, {:org_id => 1, :phone => { :department => "Отдел", :number => ""}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to org_phones_path :org_id => 1    
    end
      
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_phones_path :org_id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_phones_path :org_id => 1
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_create
      response.should redirect_to new_session_url
    end
  end
  
  describe "GET /orgs/1/phones/1/edit.html" do
    
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_edit
      get :edit, {:org_id => 1, :id => 1, :format => "html"}
    end
    
    it "should render template edit.html.haml, assign variable @org and @phone" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      phone = mock_model(Phone, :id => 150, :org_id => 1, :department => "Отдел", :number => "11111")
      Phone.stub(:find).and_return(phone)
      
      do_edit
      assigns[:org].should == @org
      assigns[:phone].should == phone
      session[:back].should == org_phones_path(:org_id => 1)
      response.should render_template("edit.html.haml")
    end
    
    it "should render the 404 page if the phone not found" do
      user_has_rights
      Phone.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)
      
      do_edit
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_edit
      response.should redirect_to new_session_url
    end
  end
  
  describe "PUT /orgs/1/phones/1.html" do
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
      Phone.stub(:find).and_return(mock_model(Phone, :id => 150, :org_id => 1, :department => "Отдел", :number => "11111"))
    end
    
    def do_update
      put :update, {:org_id => 1, :id => 1, :phone => { :department => "Отдел", :number => "11111"}, :format => "html"}
    end
    
    it "should redirect to requests_path with success flash-message if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_update
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_phones_path(:org_id => 1)
      response.should redirect_to requests_path      
    end
    
    it "should redirect to :back with error flash-message if the  params isn't valid" do
      request.env["HTTP_REFERER"] = edit_org_phone_path :org_id => 1, :id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      put :update, {:org_id => 1, :id => 1, :phone => { :department => "Отдел", :number => ""}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to edit_org_phone_path :org_id => 1, :id => 1      
    end
      
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = edit_org_phone_path :org_id => 1, :id => 1
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_update
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to edit_org_phone_path :org_id => 1, :id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = edit_org_phone_path :org_id => 1, :id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_update
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to edit_org_phone_path :org_id => 1, :id => 1
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_update
      response.should redirect_to new_session_url
    end
  end
  
  describe "DELETE /orgs/1/phones/1.html" do
    before(:each) do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
    end
    
    def do_destroy
      delete :destroy, {:org_id => 1, :id => 1, :format => "html"}
    end
    
    it "should render template destroy.html.haml, assign variable @org and @phone" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      phone = mock_model(Phone, :id => 150, :org_id => 1, :department => "Отдел", :number => "11111")
      Phone.stub(:find).and_return(phone)
      
      do_destroy
      assigns[:org].should == @org
      assigns[:phone].should == phone
      session[:back].should == org_phones_path(:org_id => 1)
      response.should render_template("destroy.html.haml")
    end
    
    it "should render the 404 page if the phone not found" do
      user_has_rights
      Phone.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)
      
      do_destroy
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_destroy
      response.should redirect_to new_session_url
    end
  end
  
  describe "DELETE /orgs/1/phones/1/delete.html" do
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
      Phone.stub(:find).and_return(mock_model(Phone, :id => 150, :org_id => 1, :department => "Отдел", :number => "11111"))
    end
    
    def do_delete
      delete :delete, {:org_id => 1, :id => 1, :request => { :msg => "Сообщение"}, :format => "html"}
    end
    
    it "should redirect to requests_path with success flash-message if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_delete
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_phones_path(:org_id => 1)
      response.should redirect_to requests_path     
    end
    
    it "should redirect to org_phones_path with error flash-message if the msg is blank" do
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      delete :delete, {:org_id => 1, :id => 1, :request => { :msg => ""}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to org_phones_path :org_id => 1        
    end
    
    it "should redirect to org_phones_path with error flash-message if the params doesn't defined" do
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      delete :delete, {:org_id => 1, :id => 1, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to org_phones_path :org_id => 1        
    end
    
    it "should redirect to org_phones_path and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_phones_path :org_id => 1
    end
    
    it "should redirect to org_phones_path and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_phones_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_phones_path :org_id => 1
    end
  end
end