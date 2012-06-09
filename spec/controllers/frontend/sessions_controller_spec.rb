require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe Frontend::SessionsController do
  fixtures        :users
  before do 
    @user  = User.new(:login => 'quentin', :email => 'quentin@example.com', :salt => '1b6453892473a467d07372d45eb05abc2031647a', :crypted_password => '893a35c92db509cffffba9d4110b6f43a10477b9', :created_at => 5.days.ago.to_s, :remember_token_expires_at => 1.days.from_now.to_s, :remember_token => 'c1dfd96eea8cc2b62785275bca38ac261256e278')
    @login_params = { :login => 'quentin', :password => 'test' }
    User.stub!(:authenticate).with(@login_params[:login], @login_params[:password]).and_return(@user)
  end
  def do_create
    post :create, @login_params
  end
  # describe "on successful login," do
  #    [ [:nil,       nil,            nil],
  #      [:expired,   'valid_token',  15.minutes.ago],
  #      [:different, 'i_haxxor_joo', 15.minutes.from_now], 
  #      [:valid,     'valid_token',  15.minutes.from_now]
  #        ].each do |has_request_token, token_value, token_expiry|
  #      [ true, false ].each do |want_remember_me|
  #        describe "my request cookie token is #{has_request_token.to_s}," do
  #          describe "and ask #{want_remember_me ? 'to' : 'not to'} be remembered" do 
  #            before do
  #              @ccookies = mock('cookies')
  #              controller.stub!(:cookies).and_return(@ccookies)
  #              @ccookies.stub!(:[]).with(:auth_token).and_return(token_value)
  #              @ccookies.stub!(:delete).with(:auth_token)
  #              @ccookies.stub!(:[]=)
  #              @user.stub!(:remember_me) 
  #              @user.stub!(:refresh_token) 
  #              @user.stub!(:forget_me)
  #              @user.stub!(:remember_token).and_return(token_value) 
  #              @user.stub!(:remember_token_expires_at).and_return(token_expiry)
  #              @user.stub!(:remember_token?).and_return(has_request_token == :valid)
  #              if want_remember_me
  #                @login_params[:remember_me] = '1'
  #              else 
  #                @login_params[:remember_me] = '0'
  #              end
  #            end
  #            it "kills existing login"        do controller.should_receive(:logout_keeping_session!); do_create; end    
  #            it "authorizes me"               do do_create; controller.send(:authorized?).should be_true;   end    
  #            it "logs me in"                  do do_create; controller.send(:logged_in?).should  be_true  end    
  #            it "greets me nicely"            do do_create; response.flash[:notice].should =~ /success/i   end
  #            it "sets/resets/expires cookie"  do controller.should_receive(:handle_remember_cookie!).with(want_remember_me); do_create end
  #            it "sends a cookie"              do controller.should_receive(:send_remember_cookie!);  do_create end
  #            it 'redirects to the home page'  do do_create; response.should redirect_to('/')   end
  #            it "does not reset my session"   do controller.should_not_receive(:reset_session).and_return nil; do_create end # change if you uncomment the reset_session path
  #            if (has_request_token == :valid)
  #              it 'does not make new token'   do @user.should_not_receive(:remember_me);   do_create end
  #              it 'does refresh token'        do @user.should_receive(:refresh_token);     do_create end 
  #              it "sets an auth cookie"       do do_create;  end
  #            else
  #              if want_remember_me
  #                it 'makes a new token'       do @user.should_receive(:remember_me);       do_create end 
  #                it "does not refresh token"  do @user.should_not_receive(:refresh_token); do_create end
  #                it "sets an auth cookie"       do do_create;  end
  #              else 
  #                it 'does not make new token' do @user.should_not_receive(:remember_me);   do_create end
  #                it 'does not refresh token'  do @user.should_not_receive(:refresh_token); do_create end 
  #                it 'kills user token'        do @user.should_receive(:forget_me);         do_create end 
  #              end
  #            end
  #          end # inner describe
  #        end
  #      end
  #    end
  #  end
   
  describe "on failed login" do
    before do
      User.should_receive(:authenticate).with(anything(), anything()).and_return(nil)
      login_as :quentin
    end
    it 'logs out keeping session'   do controller.should_receive(:logout_keeping_session!); do_create end
    it 'flashes an error'           do do_create; flash_cookie['error'].should =~ /Couldn't log you in as 'quentin'/ end
    it 'renders the log in page'    do do_create; response.should render_template('new')  end
    it "doesn't log me in"          do do_create; controller.send(:logged_in?).should == false end
    it "doesn't send password back" do 
      @login_params[:password] = 'FROBNOZZ'
      do_create
      response.should_not have_text(/FROBNOZZ/i)
    end
  end

  describe "on signout" do
    def do_destroy
      get :destroy
    end
    before do 
      login_as :quentin
    end
    it 'logs me out'                   do controller.should_receive(:logout_killing_session!); do_destroy end
    it 'redirects me to the home page' do do_destroy; response.should be_redirect     end
  end  
end

describe Frontend::SessionsController do
  
  describe "route recognition" do
    it "should generate params from GET /login correctly" do
      params_from(:get, '/login.html').should == {:controller => 'frontend/sessions', :action => 'new', :format => 'html'}
    end
    it "should generate params from POST /session correctly" do
      params_from(:post, '/session.html').should == {:controller => 'frontend/sessions', :action => 'create', :format => 'html'}
    end
    it "should generate params from DELETE /session correctly" do
      params_from(:delete, '/logout.html').should == {:controller => 'frontend/sessions', :action => 'destroy', :format => 'html'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    it "should route session_path() correctly" do
      session_path().should == "/session.html"
    end
    it "should route new_session_path() correctly" do
      new_session_path().should == "/session/new.html"
    end
  end  
end
