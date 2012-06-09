# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "Admin menu" do
#   
#   it "should contain li#current a tag with default tab if the tab is not defined" do
#     admin_menu
#     response.should have_tag('li.current a', "Главная")
#   end 
#   
#   it "should contain li#current a tag with a certain tab if the tab is defined" do
#     admin_menu("databases")
#     response.should have_tag('li.current a', "Базы данных")
#   end
# 
# end