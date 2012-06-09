# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "Org menu" do
#   
#   before(:each) do
#     template.should_receive(:org_path).and_return("/orgs/1.html")
#     template.should_receive(:org_phones_path).and_return("/orgs/1/phones.html")
#     template.should_receive(:org_activities_path).and_return("/orgs/1/activities.html")
#     template.should_receive(:org_rewiews_path).and_return("/orgs/1/rewiews.html")
#     template.should_receive(:org_tags_path).and_return("/orgs/1/tags.html")
#     template.should_receive(:edit_org_path).and_return("/orgs/1/edit.html")
#     template.should_receive(:org_path).and_return("/orgs/1.html")
#     template.should_receive(:org_favorites_path).and_return("/orgs/1.html#")
#   end
# 
#   it "should contain li#current a tag with default tab if the tab is not defined" do
#     org_menu
#     response.should have_tag('li#current a', "Карточка")
#   end 
#      
#   it "should contain li#current a tag with a certain tab if the tab is defined" do
#     org_menu("rewiews")
#     response.should have_tag('li#current a', "Отзывы")
#   end
# 
# end