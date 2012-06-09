require "#{File.dirname(__FILE__)}/../spec_helper.rb"
include ApplicationHelper

# describe "title" do
#   it "should contain only site name if no page title" do
#     title.should == content_for(:title){ "Желтые страницы Токмака" }
#   end
#   
#   it "should contain site name and page page" do
#     title('Организации').should == content_for(:title){ "Желтые страницы Токмака &#8594; Организации" }
#   end
# end
# 
# # describe "user_name" do
# #   it "should return name if name is set" do
# #     @user = Factory(:user, :login => 'Dima', :name => "admin")
# #     user_name(@user).should eql("admin")  
# #   end
# #   
# #   it "should return login if no name " do
# #     @user = Factory(:user, :login => 'dima', :name => "")
# #     user_name(@user).should eql("dima")  
# #   end
# # end
# # 
# 
# describe "date" do  
#   it "should return read if a message read" do
#     time = Time.now.ago(2)    
#     date(time).should eql(Russian::strftime(time, "Сегодня %H:%M"))  
#   end
#   
#   it "should return read if a message read" do
#     time = Time.now.yesterday   
#     date(time).should eql(Russian::strftime(time, "%d %B"))  
#   end
#   
#   it "should return read if a message read" do
#     time = Time.now.last_month   
#     date(time).should eql(Russian::strftime(time, "%d %B %Y"))  
#   end
# end
# 
# describe '' do
#   it "Should render user_bar partial" do
#     self.should_receive(:render).with(:partial => 'shared/bars/user')
#     user_bar
#   end
#   
#   it "Should render search_bar partial" do
#     self.should_receive(:render).with(:partial => 'shared/bars/search')
#     search_bar
#   end
#   
#   it "Should render admin_search partial" do
#     self.should_receive(:render).with(:partial => 'shared/bars/admin_search')
#     admin_search_bar
#   end
# end
# 
# describe 'org_menu' do
#   it "should render a certain tab if the tab is defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/org', :locals => {:current => "phones"})
#     org_menu("phones")
#   end
#   
#   it "should render default tab if the tab is not defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/org', :locals => {:current => "cart"})
#     org_menu
#   end
# end
# 
# describe 'user_menu' do
#   it "should render a certain tab if the tab is defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/user', :locals => {:current => "inbox"})
#     user_menu("inbox")
#   end
#   
#   it "should render default tab if the tab is not defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/user', :locals => {:current => "index"})
#     user_menu
#   end
# end
# 
# describe 'admin_menu' do
#   it "should render a certain tab if the tab is defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin', :locals => {:current => "databases"})
#     admin_menu("databases")
#   end
#   
#   it "should render default tab if the tab is not defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin', :locals => {:current => "main"})
#     admin_menu
#   end
# end
# 
# describe 'admin_org_menu' do
#   it "should render a certain tab if the tab is defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin_org', :locals => {:current => "phones"})
#     admin_org_menu("phones")
#   end
#   
#   it "should render default tab if the tab is not defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin_org', :locals => {:current => "cart"})
#     admin_org_menu
#   end
# end
# 
# describe 'admin_user_menu' do
#   it "should render a certain tab if the tab is defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin_user', :locals => {:current => "rewiews"})
#     admin_user_menu("rewiews")
#   end
#   
#   it "should render default tab if the tab is not defined" do
#     self.should_receive(:render).with(:partial => 'shared/menus/admin_user', :locals => {:current => "profile"})
#     admin_user_menu
#   end
# end
# 
# describe 'stat_panel' do
#   it "should render partial" do
#     self.should_receive(:render).with(:partial => 'shared/panels/profile')
#     stat_panel
#   end
# end
# 
# describe 'footer' do
#   it "should render partial" do
#     self.should_receive(:render).with(:partial => 'shared/elements_page/footer')
#     footer
#   end
# end
# 
# describe 'messages' do
#   it "should render partial" do
#     self.should_receive(:render).with(:partial => 'shared/messages/flash')
#     messages
#   end
# end
# 
# describe 'auth_notice' do
#   it "should render the partial with defined msg " do
#     self.should_receive(:render).with(:partial => 'shared/messages/auth', :locals => {:msg => "Hello"})
#     auth_notice("Hello")
#   end
# end
# 
# # TODO: Тестирование тегов
# 
# # describe 'tags' do
# #   it "should render partial" do
# #     self.should_receive(:render).with(:partial => 'shared/elements_page/tags')
# #     tags
# #   end
# # end
# 
# describe 'back_link' do
#   it "should render partial" do
#     self.should_receive(:render).with(:partial => "shared/elements_page/back_link", :locals => {:items => [:back, :orgs, :towns]})
#     back_link(:back, :orgs, :towns)
#   end
# end