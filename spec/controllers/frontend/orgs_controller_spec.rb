require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::OrgsController do
  
  describe "routing" do
    
    #         org GET    /orgs/:id(.:format)                                 {:controller=>"frontend/orgs", :action=>"show"}
    #     new_org GET    /orgs/new(.:format)                                 {:controller=>"frontend/orgs", :action=>"new"}
    #        orgs POST   /orgs(.:format)                                     {:controller=>"frontend/orgs", :action=>"create"}
    # create_orgs POST   /orgs/create(.:format)                              {:controller=>"frontend/orgs", :action=>"create"} /for passenger/
    #    edit_org GET    /orgs/:id/edit(.:format)                            {:controller=>"frontend/orgs", :action=>"edit"}  
    #             PUT    /orgs/:id(.:format)                                 {:controller=>"frontend/orgs", :action=>"update"}
    #  update_org PUT    /orgs/:id/update(.:format)                          {:controller=>"frontend/orgs", :action=>"update"} /for passenger/
    #             DELETE /orgs/:id(.:format)                                 {:controller=>"frontend/orgs", :action=>"destroy"}
    # destroy_org DELETE /orgs/:id/destroy(.:format)                         {:controller=>"frontend/orgs", :action=>"destroy"} /for passenger/
    #  delete_org DELETE /orgs/:id/delete(.:format)                          {:controller=>"frontend/orgs", :action=>"delete"}    
    
    it "should generate params { :controller => 'frontend/orgs', action => 'show', id => 1, format => 'html' } from GET /orgs/1.html" do
      params_from(:get, "/orgs/1.html").should == {:controller => "frontend/orgs", :action => "show", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'new', format => 'html' } from GET /orgs/new.html" do
      params_from(:get, "/orgs/new.html").should == {:controller => "frontend/orgs", :action => "new", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'create', format => 'html' } from POST /orgs.html" do
      params_from(:post, "/orgs.html").should == {:controller => "frontend/orgs", :action => "create", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'create', format => 'html' } from POST /orgs/create.html" do
      params_from(:post, "/orgs/create.html").should == {:controller => "frontend/orgs", :action => "create", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'edit', id => 1, format => 'html' } from GET /orgs/1/edit.html" do
     params_from(:get, "/orgs/1/edit.html").should == {:controller => "frontend/orgs", :action => "edit", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'update', id => 1, format => 'html' } from PUT /orgs/1.html" do
     params_from(:put, "/orgs/1.html").should == {:controller => "frontend/orgs", :action => "update", :id => "1", :format => "html"}
    end   
    
    it "should generate params { :controller => 'frontend/orgs', action => 'update', id => 1, format => 'html' } from PUT /orgs/1/update.html" do
     params_from(:put, "/orgs/1/update.html").should == {:controller => "frontend/orgs", :action => "update", :id => "1", :format => "html"}
    end    
    
    it "should generate params { :controller => 'frontend/orgs', action => 'destroy', id => 1, format => 'html' } from DELETE /orgs/1.html" do
     params_from(:delete, "/orgs/1.html").should == {:controller => "frontend/orgs", :action => "destroy", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'destroy', id => 1, format => 'html' } from DELETE /orgs/1/destroy.html" do
     params_from(:delete, "/orgs/1/destroy.html").should == {:controller => "frontend/orgs", :action => "destroy", :id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/orgs', action => 'delete', id => 1, format => 'html' } from DELETE /orgs/1/delete.html" do
     params_from(:delete, "/orgs/1/delete.html").should == {:controller => "frontend/orgs", :action => "delete", :id => "1", :format => "html"}
    end
  end
  
  describe "GET /orgs/1.html" do
    it "should render template show.html.haml, assign variable @org and caching page" do
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(@org)
      
      get :show, {:id => 1, :format => "html"}
      assigns[:org].should == @org
      response.should render_template("show.html.haml")    
      lambda { get :show, { :id => 1, :format => "html" } }.should cache_page('/orgs/1.html')
    end
    
    it "should render the 404 page if throw ActiveRecord::RecordNotFound exception" do      
      Org.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)
      
      get :show, { :id => 1, :format => "html" }
    end
  end
  
  describe "GET /orgs/new.html" do
    it "should render template new.html.haml" do
      request.env["HTTP_REFERER"] = root_path
      user_has_rights      
      get :new, {:format => "html"}
      session[:back].should == root_path
      response.should render_template("new.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      get :new, {:format => "html"}
      response.should redirect_to new_session_url
    end
  end
  
  describe "POST /orgs/create.html" do
    
    def do_create
      post :create, { :org => { :name => "Организация", :town_id => 1, :street_id => 1, :house => 1}, :activities => ["1", "2"], :format => "html"}
    end
    
    it "should redirect to requests_path with success flash if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = root_path
      user_has_rights
      Org.stub(:check).and_return(nil)
      Request.stub(:add).and_return(mock_model(Request))
      
      do_create
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == root_path
      response.should redirect_to requests_path
    end
    
    it "should redirect to :back and show flash message if the params isn't valid" do
      request.env["HTTP_REFERER"] = new_org_path
      user_has_rights
      
      post :create, { :org => { :name => "Организация", :town_id => 1, :street_id => 1}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")
      response.should redirect_to new_org_path
    end
    
    it "should redirect to :back and show flash message if the user has not made change" do
      request.env["HTTP_REFERER"] = new_org_path
      user_has_rights
      Org.stub(:check).and_raise(Org::RecordExist)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Или вы не внесли никаких изменений, или такая организация уже существует")
      response.should redirect_to new_org_path
    end
  
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = new_org_path
      user_has_rights
      Org.stub(:check)
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to new_org_path
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = new_org_path
      user_has_rights
      Org.stub(:check)
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to new_org_path
    end
  
    it "should redirect to login page if the user doesn't have rights" do      
      do_create
      response.should redirect_to new_session_url
    end
  end
  
  describe "GET /orgs/1/edit.html" do
    it "should render template edit.html.haml, assign variable @org if the user has rights" do
      request.env["HTTP_REFERER"] = org_path :id => 1
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      user_has_rights
      Org.stub(:find).and_return(@org)
      
      get :edit, {:id => 1, :format => "html"}
      assigns[:org].should == @org
      session[:back].should == org_path(:id => 1)
      response.should render_template("edit.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do
      get :edit, {:id => 1, :format => "html"}
      response.should redirect_to new_session_url
    end
  end
  
  describe "PUT /orgs/1.html" do
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
    end
    
    def do_edit
      put :update, {:id => 1, :org => { :name => "Организация", :town_id => 1, :street_id => 1, :house => 1}, :format => "html"}
    end
    
    it "should redirect to requests_path with success flash if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_path :id => 1
      user_has_rights      
      Org.stub(:check).and_return(nil)  
      Request.stub(:add).and_return(mock_model(Request))
      
      do_edit
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_path(:id => 1)
      response.should redirect_to requests_path      
    end
    
    it "should redirect to :back and show flash message if the params isn't valid" do
      request.env["HTTP_REFERER"] = edit_org_path :id => 1
      user_has_rights

      put :update, {:id => 1, :_method => "put", :org => { :name => "Организация", :street_id => 1, :house => 1}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")      
      response.should redirect_to edit_org_path :id => 1
    end
    
    it "should redirect to org_path and show flash message if the user has not made changes" do      
      request.env["HTTP_REFERER"] = edit_org_path :id => 1
      user_has_rights
      Org.stub(:check).and_raise(Org::RecordExist)
      
      do_edit
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Или вы не внесли никаких изменений, или такая организация уже существует")      
      response.should redirect_to edit_org_path :id => 1
    end 
    
    it "should redirect to org_path and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = edit_org_path :id => 1
      user_has_rights
      Org.stub(:check)
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_edit
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to edit_org_path :id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = edit_org_path :id => 1
      user_has_rights
      Org.stub(:check)
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_edit
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to edit_org_path :id => 1
    end
      
    it "should redirect to login page if the user doesn't have rights" do      
      do_edit
      response.should redirect_to new_session_url
    end
  end
  
  describe "DELETE /orgs/1.html" do
    it "should render template destroy.html.haml, assign variable @org if the user has rights admin or user" do
      request.env["HTTP_REFERER"] = org_path :id => 1
      @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      user_has_rights
      Org.stub(:find).and_return(@org)
      
      delete :destroy, {:id => 1, :format => "html"}
      assigns[:org].should == org_path(:id => 1) 
      response.should render_template("destroy.html.haml")
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      delete :destroy, {:id => 1, :format => "html"}
      response.should redirect_to new_session_url
    end
  end
  
  describe "DELETE /orgs/1/delete.html" do    
    
    before(:each) do
      Org.stub(:find).and_return(mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45))
    end
    
    def do_delete
      delete :delete, {:id => 1, :_method => "delete", :id => 1, :request => { :msg => "Причина" }, :format => "html"}
    end
    
    it "should redirect to requests_path with success flash if the params is valid and the request has been sent successfully" do
      request.env["HTTP_REFERER"] = org_path :id => 1
      user_has_rights
      Request.stub(:add).and_return(mock_model(Request))
      
      do_delete
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваш запрос отправлен")
      session[:back].should == org_path(:id => 1)
      response.should redirect_to requests_path      
    end
    
    it "should redirect to :back if the message is blank" do
      request.env["HTTP_REFERER"] = org_path :id => 1 
      user_has_rights
      
      delete :delete, {:id => 1, :_method => "delete", :id => 1, :request => { :msg => "" }, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Следует заполнить обязательные поля")      
      response.should redirect_to org_path :id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      user_has_rights
      Request.stub(:add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_path :id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Request.stub(:add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_delete
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_path :id => 1
    end
      
    it "should redirect to login page if the user doesn't have rights" do      
      do_delete
      response.should redirect_to new_session_url
    end
  end
  
end
