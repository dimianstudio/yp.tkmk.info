# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
# 
# describe "auth_notice" do  
#   it "should contain div.auth_notice with defined text if the msg is defined" do
#     auth_notice("Hello")
#     response.should have_tag('div.auth_notice', "Hello")
#   end 
#   
#   it "should contain div.auth_notice with default text if the msg is not defined" do
#     auth_notice
#     response.should have_tag('div.auth_notice', "Зарегистрируйтесь или авторизуйтесь")
#   end
# end