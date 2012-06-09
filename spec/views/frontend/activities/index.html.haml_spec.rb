require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница видов деятельности" do
  
  before(:each) do
    @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    Org.stub(:find).and_return(@org)
    categories = []
    3.times do |i|
      subcategories = []
      5.times do |y| subcategories << mock_model(Category, :id => (y+1)*(i+1), :parent_id => i, :name => "Подкатегория №#{y+1} категории №#{i+1}") end
      categories << mock_model(Category, :id => i+2, :parent_id => 1, :name => "Категория №#{i+1}", :children => subcategories)
    end
    Category.stub(:get_parent_categories).and_return(categories)
    @activities = []
  end
  
  it "должна содержать список и форму добавления ВД" do
    3.times do |i| @activities << mock_model(Category, :id => 10+i, :parent_id => 2+i, :name => "Категория #{10+i}", :parent => mock_model(Category, :id => 2+i, :name => "Родительская категория #{2+i}")) end           
    
    assigns[:org] = @org
    assigns[:categories] = @activities
    
    render 'frontend/activities/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/activities.html")
    response.should have_tag('li#current', "Виды деятельности")
    response.should have_tag('table#higlight_table tbody tr', :count => 3)
    response.should have_tag('a[href=/categories/11.html]', "Категория 11")
    response.should have_tag('a.delete', :count => 3)
    response.should have_tag('form[action=?]', "/orgs/1/activities/create.html")
    response.should have_tag('form[method=?]', "post")    
    response.should have_tag('div.list_checkbox p', :count => 3)
    response.should have_tag('div.list_checkbox') do
      with_tag('p', 'Категория №1')
      with_tag('p', 'Категория №2')
      with_tag('p', 'Категория №3')
    end    
    response.should have_tag('div.list_checkbox input', :count => 15)
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять или удалять виды деятельности")
  end
  
  it "должна содержать сообщение что предприятие не имеет ВД и форму добавления их" do
    assigns[:org] = @org
    assigns[:categories] = @activities
    
    render 'frontend/activities/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/activities.html")
    response.should have_tag('li#current', "Виды деятельности")
    response.should have_tag('p', "Предприятие ничем не занимается? Может Вы знаете? Тогда добавьте виды деятельности в форме ниже ;)")
    response.should have_tag('form[action=?]', "/orgs/1/activities/create.html")
    response.should have_tag('form[method=?]', "post")    
    response.should have_tag('div.list_checkbox p', :count => 3)
    response.should have_tag('div.list_checkbox') do
      with_tag('p', 'Категория №1')
      with_tag('p', 'Категория №2')
      with_tag('p', 'Категория №3')
    end    
    response.should have_tag('div.list_checkbox input', :count => 15)
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять или удалять виды деятельности")
  end
end
