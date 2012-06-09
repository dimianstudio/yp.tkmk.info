require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::CategoriesController do
  
  describe "routing" do
    
    #          category GET    /categories/:id(.:format)                           {:controller=>"frontend/categories", :action=>"show"}
    # category_paginate        /categories/:id/page/:page(.:format)                {:controller=>"frontend/categories", :action=>"show"}
        
    it "should generate params { :controller => 'frontend/categories', action => 'show', id => 2, format => 'html' } from GET /categories/2.html" do
      params_from(:get, "/categories/2.html").should == {:controller => "frontend/categories", :action => "show", :id => "2", :format => "html"}
    end

    it "should generate params { :controller => 'frontend/categories', action => 'show', id => 2, format => 'js' } from GET /categories/2.js" do
      params_from(:get, "/categories/2.js").should == {:controller => "frontend/categories", :action => "show", :id => "2", :format => "js"}
    end

    it "should generate params { :controller => 'frontend/categories', action => 'show', id => 2, page => 3, format => 'html' } from GET /categories/2/page/3.html" do
      params_from(:get, "/categories/2/page/3.html").should == {:controller => "frontend/categories", :action => "show", :id => "2", :page => "3", :format => "html"}
    end
  end
  
  describe "GET /categories/1.html" do
    
    def do_show
      get :show, { :id => 5, :format => 'html' }
    end
    
    it "should render template show.html.haml, assign variables - @current_category, @orgs, and caching page from GET /categories/1.html" do
      category = mock_model(Category, :id => 5, :parent_id => 1, :name => "Категория")
      Category.stub(:find).and_return(category)
      orgs = []
      5.times do |i|
        orgs << mock_model(Org, :id => 1+i, :name => "Организация #{i}", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45+i)
      end
      category.stub(:orgs).and_return(orgs)
      
      do_show
      assigns[:current_category].should == category
      assigns[:orgs].should == orgs
      response.should render_template("show.html.haml")    
      lambda { do_show }.should cache_page('/categories/5.html')
    end

    it "should render the 404 page if throw ActiveRecord::RecordNotFound exception" do
      Category.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
      controller.should_receive(:render).with(:file =>"#{RAILS_ROOT}/public/404.html", :status => 404)

      do_show
    end
  end
  
  describe "GET /categories/1.js" do
    it "should assign variables - @current_category, @categories and caching page from GET /categories/1.js" do
      category = mock_model(Category, :id => 5, :parent_id => 1, :name => "Категория")
      Category.stub(:find).and_return(category)
      categories = []
      5.times do |i|
        categories << mock_model(Category, :id => 5+i, :parent_id => 5, :name => "Категория #{i}")
      end
      category.stub(:children).and_return(categories)

      # TODO: Протестировать render в вызове через аякс спика подкатегорий 
      # controller.should_receive(:render).with(:partial => 'categories', :layout => false, :locals => {:categories => categories, :categories_size => 10, :category_id => 5})
      # controller.should_receive(:render).with(:partial => 'items', :locals => {:categories => categories, :categories_size => 10})

      xhr :get, :show, { :id => 5, :format => 'js' }
      assigns[:current_category].should == category
      assigns[:categories].should == categories 
      lambda { xhr :get, :show, {:id => 5, :format => "js"} }.should cache_page("/categories/5.js")
    end
  end
end
