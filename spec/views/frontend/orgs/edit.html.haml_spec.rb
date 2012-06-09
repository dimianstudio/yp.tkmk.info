require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Форма редактирования организации" do
  
  it "должна содержать все необходимые элементы" do
     @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 9, :house => "10", :email => "user@example.com", :www => "")
    towns = []
    10.times do |i|
      towns << mock_model(Town, :id => i, :name => "Город #{i}") 
    end
    streets = []
    10.times do |i| 
      streets << mock_model(Street, :id => i, :name => "Улица #{i}") 
    end    
    Town.stub(:find).and_return(towns)
    Street.stub(:find).and_return(streets) 
    
    assigns[:org] = @org
    
    render 'frontend/orgs/edit'

    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/edit.html")
    response.should have_tag('li#current', "Редактировать")
    response.should have_tag('form[action=?]', "/orgs/1/update.html")
    response.should have_tag('form[method=?]', "post")
    response.should have_tag('input[name="_method"][value=?]', "put")
    response.should have_tag('dl.required label[for=org_name]', "Название")  
    response.should have_tag('input#org_name[value=?]', "Организация")
    response.should have_tag('label[for=org_description]', "Описание") 
    response.should have_tag('textarea#org_description', "")
    response.should have_tag('dl.required label[for=org_town_id]', "Город") 
    response.should have_tag('select#org_town_id option', :count => 10)
    response.should have_tag('select#org_town_id option[selected=selected]', "Город 2")
    response.should have_tag('select#org_town_id option[value=2]', "Город 2")
    response.should have_tag('dl.required label[for=org_street_id]', "Улица")
    response.should have_tag('select#org_street_id option', :count => 10)
    response.should have_tag('select#org_street_id option[selected=selected]', "Улица 9")
    response.should have_tag('select#org_street_id option[value=9]', "Улица 9")
    response.should have_tag('dl.required label[for=org_house]', "Дом")
    response.should have_tag('input#org_house[value=?]', "10")
    response.should have_tag('label[for=org_email]', "E-mail")
    response.should have_tag('input#org_email[value=?]', "user@example.com")
    response.should have_tag('label[for=org_www]', "Веб-сайт")
    response.should have_tag('input#org_www[value=?]', "")
    response.should have_tag('input.button[value=?]', "Редактировать")
    response.should have_tag('div.back_link a', :count => 1)
    response.should have_tag('div.back_link a[href=javascript:history.back();]', "&lt;&lt; Вернутся назад")
  end
end
