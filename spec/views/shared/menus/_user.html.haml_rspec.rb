# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "User menu" do
#   
#   it "should contain li#current a tag with default tab if the tab is not defined" do
#     user_menu
#     response.should have_tag('li#current a', "Главная")
#   end 
#   
#   it "should contain li#current a tag with a certain tab if the tab is defined" do
#     user_menu("inbox")
#     response.should have_tag('li#current a', "Сообщения")
#   end
# 
# end