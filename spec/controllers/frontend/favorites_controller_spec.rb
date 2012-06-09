require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::FavoritesController do

  describe "routing" do
    
    # profile_favorites        /profile/favorites(.:format)                        {:controller=>"frontend/favorites", :action=>"index"}
    # favorites_paginate       /profile/favorites/page/:page(.:format)             {:controller=>"frontend/favorites", :action=>"index"}  
    #                   POST   /orgs/:org_id/favorites(.:format)                   {:controller=>"frontend/favorites", :action=>"create"}
    #      org_favorite DELETE /orgs/:org_id/favorites/:id(.:format)               {:controller=>"frontend/favorites", :action=>"destroy"}  
    
    it "should generate params { controller => 'frontend/favorites', action => 'index', format => 'html' } from GET /profile/favorites.html" do
      params_from(:get, "/profile/favorites.html").should == {:controller => "frontend/favorites", :action => "index", :format => "html"}
    end
    
    it "should generate params { controller => 'frontend/favorites', action => 'index', page => 1, format => 'html' } from GET /profile/favorites/page/1.html" do
      params_from(:get, "/profile/favorites/page/1.html").should == {:controller => "frontend/favorites", :action => "index", :page => "1", :format => "html"}
    end
    
    it "should generate params { controller => 'frontend/favorites', action => 'create', :org_id => 1, format => 'js' } from POST /orgs/1/favorites.js" do
      params_from(:post, "/orgs/1/favorites.js").should == {:controller => "frontend/favorites", :action => "create", :org_id => "1", :format => "js"}
    end
    
    it "should generate params { controller => 'frontend/favorites', action => 'create', :org_id => 1, format => 'js' } from POST /orgs/1/favorites/1.html" do
      params_from(:delete, "/orgs/1/favorites/1.html").should == {:controller => "frontend/favorites", :action => "destroy", :org_id => "1", :id => "1", :format => "html"}
    end
  end
  
  describe "GET /profile/favorites.html" do
    
    def do_index
      get :index, :format => "html"
    end
    
    it "should render template index.html.haml, assign variable @favorites" do
      user_has_rights
      favorites = []
      5.times do |i| favorites << mock_model(Favorite, :id => i, :org_id => 1+i, :user_id => 1) end        
      Favorite.stub(:find).and_return(favorites)
      
      do_index
      assigns[:favorites].should == favorites
      response.should render_template("index.html.haml")
      
      # TODO: Протестировать кеширование страниц избранного
      # lambda { do_index }.should cache_fragment('favorite/user_1/page_1.cache')
    end
    
    it "should redirect to login page if the user doesn't have rights" do      
      do_index
      response.should redirect_to new_session_url
    end
  end
  
  describe "POST /orgs/1/favorites.js" do    
    
    def do_create
      post :create, {:org_id => 1, :format => "js"} 
    end
    
    it "should show success flash if the user has rights admin or user and the params is valid" do
      user_has_rights
      Favorite.stub(:add!)
      controller.should_receive(:render).with(:partial => 'success', :layout => false, :locals => {:msg => "Организация успешно добавлена в Избранное"})
      
      do_create   
    end
    
    it "should show error flash if the org belongs to favorites" do
      user_has_rights
      Favorite.stub(:add!).and_raise(Favorite::RecordExist)
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Такая запись уже есть"})
      
      do_create    
    end
    
    it "should show error flash if throw ActiveRecord::RecordNotSaved exception" do      
      user_has_rights
      Favorite.stub(:add!).and_raise(ActiveRecord::RecordNotSaved)
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Извините произошла ошибка!!!"})
      
      do_create
    end
        
    it "should show error flash if throw ActiveRecord::RecordInvalid exception" do      
      user_has_rights
      model = mock("model")
      errors = mock("errors")
      model.stub!(:errors).and_return(errors)
      errors.stub!(:full_messages).and_return([])
      Favorite.stub(:add!).and_raise(ActiveRecord::RecordInvalid.new(model))
      controller.should_receive(:render).with(:partial => 'error', :layout => false, :locals => {:msg => "Извините произошла ошибка!!!"})
      
      do_create
    end
    
    it "should render inline text 'error' if the user doesn't have rights" do 
      controller.should_receive(:render).with(:inline => 'error')           
      do_create
    end    
  end
  
  describe "DELETE /orgs/1/favorites/1.html" do
    
    def do_destroy
      delete :destroy, {:org_id => 1, :id => 1, :format => "js"}
    end
    
    it "should show success flash if the user has rights and the favorite is deleted" do
      user_has_rights
      Favorite.stub(:delete_all)
      controller.should_receive(:render).with(:partial => 'success', :layout => false, :locals => {:msg => "Организация успешно удалена из Избранного"})
      
      do_destroy
    end
    
    it "should render inline text 'error' if the user doesn't have rights" do 
      controller.should_receive(:render).with(:inline => 'error')           
      do_destroy
    end
  end

end
