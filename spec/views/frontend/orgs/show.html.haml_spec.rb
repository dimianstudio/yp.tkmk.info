require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Карточка организации" do
  
  it "должна содержать блок адрес (Город, Улица)" do
    @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 15, :house => "", :email => "", :www => "")
    town = mock_model(Town, :id => 2, :name => "Токмак")
    street = mock_model(Street, :id => 15, :name => "Шевченко")
    @org.stub(:town).and_return(town)
    @org.stub(:street).and_return(street)
    @org.stub(:categories).and_return(nil)
    @org.stub(:phones).and_return(nil)
    
    assigns[:org] = @org
    render 'frontend/orgs/show'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1.html")
    response.should have_tag('li#current', "Карточка")
    response.should have_tag('fieldset.last legend', "Адрес")
    response.should_not have_tag('fieldset legend', "Контакты")
    response.should_not have_tag('fieldset legend', "Вид деятельности")
    response.should_not have_tag('fieldset legend', "Описание")
    response.should have_tag('div.town', "Город: Токмак")
    response.should have_tag('div.street', "Улица: Шевченко")
    response.should_not have_tag('div.house')      
  end
  
  it "должна содержать блоки - адрес (Город, Улица, Дом) и контакты (Позвонить)" do
    @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45, :email => "", :www => "")
    town = mock_model(Town, :id => 2, :name => "Токмак")
    street = mock_model(Street, :id => 15, :name => "Шевченко")
    phone = mock_model(Phone, :id => 54, :department => "", :number => 44444)
    @org.stub(:town).and_return(town)
    @org.stub(:street).and_return(street)
    @org.stub(:categories).and_return(nil)
    @org.stub(:phones).and_return(phone)
    
    assigns[:org] = @org
    render 'frontend/orgs/show'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1.html")
    response.should have_tag('li#current', "Карточка")
    response.should have_tag('fieldset legend', "Адрес")
    response.should have_tag('fieldset.last legend', "Контакты")
    response.should_not have_tag('fieldset legend', "Вид деятельности")
    response.should_not have_tag('fieldset legend', "Описание") 
    response.should have_tag('div.house', "Дом: 45") 
    response.should have_tag('a.phone', "Позвонить")
    response.should have_tag('a.phone[href=?]', "/orgs/1/phones.html")
  end
  
  it "должна содержать блоки - адрес (Город, Улица, Дом) и контакты (Написать e-mail, Посетить веб-сайт) " do
    @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45, :email => "user@example.com", :www => "http://www.example.com")
    town = mock_model(Town, :id => 2, :name => "Токмак")
    street = mock_model(Street, :id => 15, :name => "Шевченко")
    @org.stub(:town).and_return(town)
    @org.stub(:street).and_return(street)
    @org.stub(:categories).and_return(nil)
    @org.stub(:phones).and_return(nil)
    
    assigns[:org] = @org
    render 'frontend/orgs/show'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1.html")
    response.should have_tag('li#current', "Карточка")
    response.should have_tag('fieldset legend', "Адрес")
    response.should have_tag('fieldset.last legend', "Контакты")
    response.should_not have_tag('fieldset legend', "Вид деятельности")
    response.should_not have_tag('fieldset legend', "Описание") 
    response.should have_tag('a.email', "Написать письмо")
    response.should have_tag('a.email[href=?]', "&#109;&#97;&#105;&#108;&#116;&#111;&#58;%75%73%65%72@%65%78%61%6d%70%6c%65.%63%6f%6d")
    response.should have_tag('a.www', "Посетить веб-сайт")
    response.should have_tag('a.www[href=?]', "http://www.example.com")
  end
  
  it "должна содержать блоки - адрес (Город, Улица, Дом), контакты (Позвонить) и описание" do
    @org = mock_model(Org, :id => 1, :name => "Организация", :description => "Описание", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45, :email => "", :www => "")
    town = mock_model(Town, :id => 2, :name => "Токмак")
    street = mock_model(Street, :id => 15, :name => "Шевченко")
    phone = mock_model(Phone, :id => 54, :department => "", :number => 44444)
    @org.stub(:town).and_return(town)
    @org.stub(:street).and_return(street)
    @org.stub(:categories).and_return(nil)
    @org.stub(:phones).and_return(phone)
    
    assigns[:org] = @org
    render 'frontend/orgs/show'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1.html")
    response.should have_tag('li#current', "Карточка")
    response.should have_tag('fieldset legend', "Адрес")
    response.should have_tag('fieldset legend', "Контакты")
    response.should_not have_tag('fieldset legend', "Вид деятельности")
    response.should have_tag('fieldset.last legend', "Описание") 
    response.should have_tag('a.phone', "Позвонить")
    response.should have_tag('a.phone[href=?]', "/orgs/1/phones.html")
    response.should have_tag('fieldset.last span', "Описание")
  end
  
  it "должна содержать блоки - адрес (Город, Улица, Дом) и виды деятельности" do
    @org = mock_model(Org, :id => 1, :name => "Организация", :description => "", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45, :email => "", :www => "")
    town = mock_model(Town, :id => 2, :name => "Токмак")
    street = mock_model(Street, :id => 15, :name => "Шевченко")
    category = []
    category << mock_model(Category, :id => 10, :parent_id => 2, :name => "Категория", :parent => mock_model(Category, :id => 2, :name => "Родительская категория"))
    @org.stub(:town).and_return(town)
    @org.stub(:street).and_return(street)
    @org.stub(:categories).and_return(category)
    @org.stub(:phones).and_return(nil)
    
    assigns[:org] = @org
    render 'frontend/orgs/show'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1.html")
    response.should have_tag('li#current', "Карточка")
    response.should have_tag('fieldset legend', "Адрес")
    response.should_not have_tag('fieldset legend', "Контакты")
    response.should have_tag('fieldset.last legend', "Вид деятельности")
    response.should_not have_tag('fieldset legend', "Описание") 
    response.should have_tag('td', "Родительская категория &#8594; Категория")
    response.should have_tag('td a[href=?]', "/categories/10.html")
  end
end
