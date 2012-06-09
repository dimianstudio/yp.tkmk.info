require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница телефонов" do
  
  before(:each) do
    @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    Org.stub(:find).and_return(@org)
    @phones = []
  end
  
  it "должна содержать список телефонов без списка страниц и форму добавления телефона" do
    8.times do |i|
      @phones << mock_model(Phone, :id => i, :org_id => 1, :department => "Отдел №#{i}", :number => "1111#{i}")
    end
    @phones.stub(:total_entries).and_return(8)
    @phones.stub(:total_pages).and_return(0)     
    
    assigns[:org] = @org
    assigns[:phones] = @phones
    
    render 'frontend/phones/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/phones.html")
    response.should have_tag('li#current', "Телефоны")
    response.should have_tag('table#higlight_table tbody tr', :count => 8)
    response.should have_tag('form[action=?]', "/orgs/1/phones/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('label[for=phone_department]', "Название отдела")  
    response.should have_tag('input#phone_department') 
    response.should have_tag('dl.required label[for=phone_number]', "Номер телефона") 
    response.should have_tag('dl.required input#phone_number')
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять, редактировать или удалять телефоны")
  end
  
  it "должна содержать список телефонов со списком страниц и форму добавления телефона" do
    10.times do |i|
      @phones << mock_model(Phone, :id => i, :org_id => 1, :department => "Отдел №#{i}", :number => "1111#{i}")
    end
    @phones.stub(:total_entries).and_return(12)
    @phones.stub(:total_pages).and_return(2)   
    @phones.stub(:current_page).and_return(1)
    @phones.stub(:previous_page).and_return(0)  
    @phones.stub(:next_page).and_return(2)   
    
    assigns[:org] = @org
    assigns[:phones] = @phones
    
    render 'frontend/phones/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/phones.html")
    response.should have_tag('li#current', "Телефоны")
    response.should have_tag('div.pagination')
    response.should have_tag('span.current', "1")
    response.should have_tag('a[rel=next]', "2")
    response.should have_tag('a.next_page', "Вперед &raquo;")
    response.should have_tag('table#higlight_table tbody tr', :count => 10)
    response.should have_tag('form[action=?]', "/orgs/1/phones/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('label[for=phone_department]', "Название отдела")  
    response.should have_tag('input#phone_department') 
    response.should have_tag('dl.required label[for=phone_number]', "Номер телефона") 
    response.should have_tag('dl.required input#phone_number')
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять, редактировать или удалять телефоны")
  end
  
  it "должна содержать сообщение, что телефонов нет и форму добавления телефона" do
    @phones.stub(:total_entries).and_return(0)
    @phones.stub(:total_pages).and_return(0)     
    
    assigns[:org] = @org
    assigns[:phones] = @phones
    
    render 'frontend/phones/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/phones.html")
    response.should have_tag('li#current', "Телефоны")
    response.should have_tag('table#higlight_table tbody tr', :count => 0)
    response.should have_tag('p', "Странно, но организация не имеет телефонов :(")
    response.should have_tag('form[action=?]', "/orgs/1/phones/create.html")
    response.should have_tag('form[method=?]', "post") 
    response.should have_tag('label[for=phone_department]', "Название отдела")  
    response.should have_tag('input#phone_department') 
    response.should have_tag('dl.required label[for=phone_number]', "Номер телефона") 
    response.should have_tag('dl.required input#phone_number') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять, редактировать или удалять телефоны")
  end
end
