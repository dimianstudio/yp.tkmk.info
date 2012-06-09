require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница редактирования телефона" do
  
  it "должна содержать форму для редактирования телефона" do
    org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    phone = mock_model(Phone, :id => 45, :org_id => 1, :department => "Отдел", :number => "11111") 
    Org.stub(:find).and_return(org)    
    Phone.stub(:find).and_return(phone)
    
    assigns[:org] = org
    assigns[:phone] = phone
    
    render 'frontend/phones/edit'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/phones.html")
    response.should have_tag('li#current', "Телефоны")
    response.should have_tag('h3', "Редактировать телефон")
    response.should have_tag('form[action=?]', "/orgs/1/phones/45.html")
    response.should have_tag('form[method=?]', "post") 
    response.should have_tag('input[name=_method][value=?]', "put")
    response.should have_tag('label[for=phone_department]', "Название отдела")  
    response.should have_tag('input#phone_department[value=?]', "Отдел") 
    response.should have_tag('dl.required label[for=phone_number]', "Номер телефона")  
    response.should have_tag('dl.required input#phone_number[value=?]', "11111") 
    response.should have_tag('input.button[value=?]', "Редактировать")
  end
end
