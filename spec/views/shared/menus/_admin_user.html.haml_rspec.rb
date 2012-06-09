# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "Admin user menu" do
#   
#   before(:each) do
#     template.should_receive(:backend_user_path).and_return("backend/users/1.html")
#     template.should_receive(:backend_user_rights_path).and_return("backend/users/1/roles.html")
#     template.should_receive(:backend_user_orgs_path).and_return("backend/users/1/orgs.html")
#     template.should_receive(:backend_user_requests_path).and_return("backend/users/1/requests.html")
#     template.should_receive(:backend_user_rewiews_path).and_return("backend/users/1/rewiews.html")
#     template.should_receive(:backend_user_path).and_return("backend/users/1.html")
#   end
# 
#   it "should contain li#current a tag with default tab if the tab is not defined" do
#     admin_user_menu
#     response.should have_tag('li#current a', "Профиль")
#   end 
#      
#   it "should contain li#current a tag with a certain tab if the tab is defined" do
#     admin_user_menu("rewiews")
#     response.should have_tag('li#current a', "Отзывы")
#   end
# 
# end