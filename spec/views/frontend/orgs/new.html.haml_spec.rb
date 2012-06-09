require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Форма создания организации" do
  
  it "должна содержать все необходимые элементы" do
    towns = []
    10.times do |i|
      towns << mock_model(Town, :id => i, :name => "Город #{i}") 
    end
    streets = []
    10.times do |i| 
      streets << mock_model(Street, :id => i, :name => "Улица #{i}") 
    end    
    categories = []
    3.times do |i|
      subcategories = []
      5.times do |y| subcategories << mock_model(Category, :id => (y+1)*(i+1), :parent_id => i, :name => "Подкатегория №#{y+1} категории №#{i+1}") end
      categories << mock_model(Category, :id => i+2, :parent_id => 1, :name => "Категория №#{i+1}", :children => subcategories)
    end
    Category.stub(:get_parent_categories).and_return(categories)
    Town.stub(:find).and_return(towns)
    Street.stub(:find).and_return(streets)
    
    render 'frontend/orgs/new'

    response.should have_tag('h2', "Запрос на добавление организации")
    response.should have_tag('form[action=?]', "/orgs/create.html")
    response.should have_tag('form[method=?]', "post")
    response.should have_tag('label[for=?]', "org_name")
    response.should have_tag('label', "Название")
    response.should have_tag('input#org_name')
    response.should have_tag('label[for=?]', "org_description")
    response.should have_tag('label', "Описание")
    response.should have_tag('textarea#org_description')
    response.should have_tag('label[for=?]', "org_town_id")
    response.should have_tag('label', "Город")
    response.should have_tag('select#org_town_id')
    response.should have_tag('select#org_town_id option', :count => 11)
    response.should have_tag('label[for=?]', "org_street_id")
    response.should have_tag('label', "Улица")
    response.should have_tag('select#org_street_id')
    response.should have_tag('select#org_street_id option', :count => 11)
    response.should have_tag('label[for=?]', "org_house")
    response.should have_tag('label', "Дом")
    response.should have_tag('input#org_house')
    response.should have_tag('label[for=?]', "org_email")
    response.should have_tag('label', "E-mail")
    response.should have_tag('input#org_email')
    response.should have_tag('label[for=?]', "org_www")
    response.should have_tag('label', "Веб-сайт")
    response.should have_tag('input#org_www')
    response.should have_tag('div.list_checkbox p', :count => 3)
    response.should have_tag('div.list_checkbox') do
      with_tag('p', 'Категория №1')
      with_tag('p', 'Категория №2')
      with_tag('p', 'Категория №3')
    end    
    response.should have_tag('div.list_checkbox input', :count => 15)
    response.should have_tag('input#activity_3[value=?]', 3)
    response.should have_tag('div.tip[style=?]', "float:right; width:100px;padding-top:25px;")
    response.should have_tag('a', "Добавить строку")
    response.should have_tag('div#phones') do
      with_tag('div.phone_row')
      with_tag('div.phone_row div.department')
      with_tag('div.phone_row div.number')
      with_tag('div.phone_row div.department input#phone_department')
      with_tag('div.phone_row div.number input#phone_number')
    end
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.back_link a', :count => 1)
    response.should have_tag('div.back_link a[href=javascript:history.back();]', "&lt;&lt; Вернутся назад")
  end
end
