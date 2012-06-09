require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::TagsController do

  describe "routing" do
    
    #        org_tags GET    /orgs/:org_id/tags(.:format)                        {:controller=>"frontend/tags", :action=>"index"}
    #                 POST   /orgs/:org_id/tags(.:format)                        {:controller=>"frontend/tags", :action=>"create"}
    # create_org_tags POST   /orgs/:org_id/tags/create(.:format)                 {:controller=>"frontend/tags", :action=>"create"} /for passenger/
    #             tag        /tag/:id(.:format)                                  {:controller=>"frontend/tags", :action=>"show"}
    #    tag_paginate        /tag/:id/page/:page(.:format)                       {:controller=>"frontend/tags", :action=>"show"}
    
    it "should generate params { :controller => 'frontend/tags', action => 'index', org_id => 1, format => 'html' } from GET /orgs/1/tags.html" do
      params_from(:get, "/orgs/1/tags.html").should == {:controller => "frontend/tags", :action => "index", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/tags', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/tags.html" do
      params_from(:post, "/orgs/1/tags.html").should == {:controller => "frontend/tags", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/tags', action => 'create', org_id => 1, format => 'html' } from POST /orgs/1/tags/create.html" do
      params_from(:post, "/orgs/1/tags/create.html").should == {:controller => "frontend/tags", :action => "create", :org_id => "1", :format => "html"}
    end
    
    it "should generate params { :controller => 'frontend/tags', action => 'show', id => 1, format => 'html' } from GET /tag/1.html" do
     params_from(:get, "/tag/1.html").should == {:controller => "frontend/tags", :action => "show", :id => "1", :format => "html"}
    end  
    
    it "should generate params { :controller => 'frontend/tags', action => 'show', id => 1, :page => 2, format => 'html' } from GET /tag/1/page/2.html" do
     params_from(:get, "/tag/1/page/2.html").should == {:controller => "frontend/tags", :action => "show", :id => "1", :page => "2", :format => "html"}
    end
  end

  describe "GET /orgs/1/tags.html" do  
    def do_index
      get :index, {:org_id => 1, :format => "html"}
    end
    
    it "should render template index.html.haml, assign variable @tags, @org and caching page" do
      org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
      Org.stub(:find).and_return(org)
      tags = [mock_model(Tag, :id => 50, :name => "Тэг", :user_id => 1)]
      org.stub(:tags).and_return(tags)
      
      do_index
      assigns[:org].should == org
      assigns[:tags].should == tags
      response.should render_template("index.html.haml")    
      lambda { get :index, {:org_id => 1, :format => "html"} }.should cache_page('/orgs/1/tags.html')
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
      post :create, {:org_id => 1, :tag => { :string => "тэг"}, :format => "html"}
    end
    
    it "should redirect to :back with success flash-message if the params is valid and the tags" do
      request.env["HTTP_REFERER"] = org_tags_path :org_id => 1
      user_has_rights
      tag = mock_model(Tag, :id => 50, :name => "Тэг", :user_id => 1)
      Tag.stub(:find_or_add).and_return(tag)
      Association.stub(:find_or_add)
      
      do_create
      flash_cookie['notice'].should_not be_nil
      flash_cookie['notice'].should eql("Спасибо, Ваши тэги успешно присвоены")
      response.should redirect_to org_tags_path :org_id => 1      
    end
    
    it "should redirect to :back with error flash-message if the  params isn't valid" do
      request.env["HTTP_REFERER"] = org_tags_path :org_id => 1
      user_has_rights
      
      post :create, {:org_id => 1, :tag => { :string => ""}, :format => "html"}
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Введите хоть что-то")
      response.should redirect_to org_tags_path :org_id => 1    
    end
      
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordNotSaved exception" do      
      request.env["HTTP_REFERER"] = org_tags_path :org_id => 1
      user_has_rights
      tag = mock_model(Tag, :id => 50, :name => "Тэг", :user_id => 1)
      Tag.stub(:find_or_add).and_return(tag)
      Association.stub(:find_or_add).and_raise(ActiveRecord::RecordNotSaved)
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_tags_path :org_id => 1
    end
    
    it "should redirect to :back and show flash message if throw ActiveRecord::RecordInvalid exception" do      
      request.env["HTTP_REFERER"] = org_tags_path :org_id => 1
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      tag = mock_model(Tag, :id => 50, :name => "Тэг", :user_id => 1)
      Tag.stub(:find_or_add).and_return(tag)
      Association.stub(:find_or_add).and_raise(ActiveRecord::RecordInvalid.new(model))
      
      do_create
      flash_cookie['error'].should_not be_nil
      flash_cookie['error'].should eql("Извините, произошла ошибка!!!")      
      response.should redirect_to org_tags_path :org_id => 1
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_create
      response.should redirect_to new_session_url
    end
  end
  
  describe "GET /tag/1.html" do
    
    def do_show
      get :show, {:id => 1, :format => "html"}
    end
    
    it "should render template show.html.haml, assign variable @tag, @orgs and caching page" do
      tag = mock_model(Tag, :id => 1, :name => "Тэг", :user_id => 1)
      Tag.stub(:find).and_return(tag)
      orgs = []
      10.times do |i| orgs << mock_model(Org, :id => i, :name => "Организация #{i}", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45+i) end
      tag.stub(:orgs).and_return(orgs)
      
      do_show
      assigns[:orgs].should == orgs
      assigns[:tag].should == tag
      response.should render_template("show.html.haml")    
      lambda { do_show }.should cache_page('/tag/1.html')
    end
    
    it "should render the 404 page if the tag not found" do
      Tag.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)
  
      do_show
    end
  end

end