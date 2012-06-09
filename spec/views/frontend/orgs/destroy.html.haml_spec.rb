require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Форма удаления организации" do
  
  it "должна содержать все необходимые элементы" do
     @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 9, :house => "10", :email => "user@example.com", :www => "")
    
    assigns[:org] = @org
    
    render 'frontend/orgs/destroy'

    response.should have_tag('h2', "Организация")
    response.should have_tag('h3', "Удалить организацию")
    response.should have_tag('li#current a[href=?]', "/orgs/1/destroy.html")
    response.should have_tag('li#current', "Удалить")
    response.should have_tag('form[action=?]', "/orgs/1/delete.html")
    response.should have_tag('form[method=?]', "post")
    response.should have_tag('input[name="_method"][value=?]', "delete")
    response.should have_tag('div.remove-info p', "Название организации: Организация")
    response.should have_tag('div.required textarea#request_msg', "")
    response.should have_tag('input.button[value=?]', "Удалить")
    response.should have_tag('div.back_link a', :count => 1)
    response.should have_tag('div.back_link a[href=javascript:history.back();]', "&lt;&lt; Вернутся назад")
  end
end
