require "#{File.dirname(__FILE__)}/../../spec_helper.rb"
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe Frontend::UsersController do
  fixtures :users

  it 'allows signup' do
    lambda do
      create_user
      response.should be_redirect
    end.should change(User, :count).by(1)
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end  
  
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe Frontend::UsersController do
  
  describe "route recognition" do
    it "should generate params for users's index action from GET /users" do
      params_from(:get, '/users').should == {:controller => 'frontend/users', :action => 'index'}
      params_from(:get, '/users.xml').should == {:controller => 'frontend/users', :action => 'index', :format => 'xml'}
      params_from(:get, '/users.json').should == {:controller => 'frontend/users', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for users's new action from GET /users" do
      params_from(:get, '/users/new').should == {:controller => 'frontend/users', :action => 'new'}
      params_from(:get, '/users/new.xml').should == {:controller => 'frontend/users', :action => 'new', :format => 'xml'}
      params_from(:get, '/users/new.json').should == {:controller => 'frontend/users', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for users's create action from POST /users" do
      params_from(:post, '/users').should == {:controller => 'frontend/users', :action => 'create'}
      params_from(:post, '/users.xml').should == {:controller => 'frontend/users', :action => 'create', :format => 'xml'}
      params_from(:post, '/users.json').should == {:controller => 'frontend/users', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for users's show action from GET /users/1" do
      params_from(:get , '/users/1').should == {:controller => 'frontend/users', :action => 'show', :id => '1'}
      params_from(:get , '/users/1.xml').should == {:controller => 'frontend/users', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/users/1.json').should == {:controller => 'frontend/users', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for users's edit action from GET /users/1/edit" do
      params_from(:get , '/users/1/edit').should == {:controller => 'frontend/users', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'users', :action => update', :id => '1'} from PUT /users/1" do
      params_from(:put , '/users/1').should == {:controller => 'frontend/users', :action => 'update', :id => '1'}
      params_from(:put , '/users/1.xml').should == {:controller => 'frontend/users', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/users/1.json').should == {:controller => 'frontend/users', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for users's destroy action from DELETE /users/1" do
      params_from(:delete, '/users/1').should == {:controller => 'frontend/users', :action => 'destroy', :id => '1'}
      params_from(:delete, '/users/1.xml').should == {:controller => 'frontend/users', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/users/1.json').should == {:controller => 'frontend/users', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route users_path() to /users" do
      users_path().should == "/users.html"
      users_path(:format => 'xml').should == "/users.xml"
      users_path(:format => 'json').should == "/users.json"
    end
    
    it "should route new_user_path() to /users/new" do
      new_user_path().should == "/users/new.html"
      new_user_path(:format => 'xml').should == "/users/new.xml"
      new_user_path(:format => 'json').should == "/users/new.json"
    end
    
    it "should route user_(:id => '1') to /users/1" do
      user_path(:id => '1').should == "/users/1.html"
      user_path(:id => '1', :format => 'xml').should == "/users/1.xml"
      user_path(:id => '1', :format => 'json').should == "/users/1.json"
    end
    
    it "should route edit_user_path(:id => '1') to /users/1/edit" do
      edit_user_path(:id => '1').should == "/users/1/edit.html"
    end
  end
  
end
