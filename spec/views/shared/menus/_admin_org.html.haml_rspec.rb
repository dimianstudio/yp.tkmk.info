# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "Admin org menu" do
#   
#   before(:each) do
#     template.should_receive(:backend_org_path).and_return("backend/orgs/1.html")
#     template.should_receive(:backend_org_phones_path).and_return("backend/orgs/1/phones.html")
#     template.should_receive(:backend_org_activities_path).and_return("backend/orgs/1/activities.html")
#     template.should_receive(:backend_orgs_rewiews_path).and_return("backend/orgs/1/rewiews.html")
#     template.should_receive(:backend_orgs_associations_path).and_return("backend/orgs/1/associations.html")
#     template.should_receive(:backend_orgs_requests_path).and_return("backend/orgs/1/requests.html")
#     template.should_receive(:backend_org_path).and_return("backend/orgs/1.html")
#   end
# 
#   it "should contain li#current a tag with default tab if the tab is not defined" do
#     admin_org_menu
#     response.should have_tag('li#current a', "Карточка")
#   end 
#      
#   it "should contain li#current a tag with a certain tab if the tab is defined" do
#     admin_org_menu("phones")
#     response.should have_tag('li#current a', "Телефоны")
#   end
# 
# end