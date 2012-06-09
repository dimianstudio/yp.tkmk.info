require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница удаления телефона" do
  
  it "должна содержать форму для удаления телефона и блок с информацией для удаления" do
    org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    phone = mock_model(Phone, :id => 45, :org_id => 1, :department => "Отдел", :number => "11111") 
    Org.stub(:find).and_return(org)    
    Phone.stub(:find).and_return(phone)
    
    assigns[:org] = org
    assigns[:phone] = phone
    
    render 'frontend/phones/destroy'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/phones.html")
    response.should have_tag('li#current', "Телефоны")
    response.should have_tag('h3', "Удалить телефон")
    response.should have_tag('div.remove-info')
    response.should have_tag('div.remove-info p strong', :count => 2)
    response.should have_tag('div.remove-info p', "Отдел: Отдел")
    response.should have_tag('div.remove-info p', "Номер телефона: 11111")
    response.should have_tag('form[action=?]', "/orgs/1/phones/45/delete.html")
    response.should have_tag('form[method=?]', "post") 
    response.should have_tag('div.required textarea#request_msg')
    response.should have_tag('input.button[value=?]', "Удалить")
  end
end
