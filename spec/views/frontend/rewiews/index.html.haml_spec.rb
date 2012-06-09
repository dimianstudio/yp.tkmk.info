require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница комментариев" do
  
  before(:each) do
    @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    Org.stub(:find).and_return(@org)
    @rewiews = []
  end
  
  it "должна содержать список отзывов без списка страниц и форму добавления комментария" do    
    4.times do |i|
      user = mock_model(User, :id => i, :login => "user_#{i}", :name => "")
      user.stub(:has_role?).with("admin").and_return(false)
      @rewiews << mock_model(Rewiew, :id => i, :text => "Комментарий #{i}", :org_id => 1, :user_id => i, :user => user, :created_at => DateTime.new(2010, 01, 01, 10, 30, 00))
    end
    user = mock_model(User, :id => 5, :login => "admin", :name => "administrator")
    user.stub(:has_role?).with("admin").and_return(true)
    @rewiews << mock_model(Rewiew, :id => 5, :text => "Комментарий 5", :org_id => 1, :user_id => 5, :user => user, :created_at => DateTime.new(2010, 01, 10, 10, 50, 00))
    @rewiews.stub(:total_entries).and_return(5)
    @rewiews.stub(:total_pages).and_return(0)     
    
    assigns[:org] = @org
    assigns[:rewiews] = @rewiews
    
    render 'frontend/rewiews/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/rewiews.html")
    response.should have_tag('li#current', "Отзывы")
    response.should have_tag('div#rewiews div', :count => 5)
    response.should have_tag('div#rewiew_3 div.rewiew-title div.rewiew-user', "user_3")
    response.should have_tag('div#rewiew_3 div.rewiew-title div.rewiew-date', "01 января 2010 г.")
    response.should have_tag('div#rewiew_3 div.rewiew-text', "Комментарий 3")    
    response.should have_tag('div#rewiew_5 div.rewiew-title div.rewiew-user', "Администратор")
    response.should have_tag('div#rewiew_5 div.rewiew-title div.rewiew-date', "10 января 2010 г.")
    response.should have_tag('div#rewiew_5 div.rewiew-text', "Комментарий 5")
    response.should_not have_tag('div.pagination')
    response.should have_tag('form[action=?]', "/orgs/1/rewiews/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('textarea#rewiew_text') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять комментарии")
  end
  
  it "должна содержать список отзывов со списком страниц и форму добавления комментария" do
    4.times do |i|
      user = mock_model(User, :id => i, :login => "user_#{i}", :name => "")
      user.stub(:has_role?).with("admin").and_return(false)
      @rewiews << mock_model(Rewiew, :id => i, :text => "Комментарий #{i}", :org_id => 1, :user_id => i, :user => user, :created_at => DateTime.new(2010, 01, 01, 10, 30, 00))
    end
    user = mock_model(User, :id => 5, :login => "admin", :name => "administrator")
    user.stub(:has_role?).with("admin").and_return(true)
    @rewiews << mock_model(Rewiew, :id => 5, :text => "Комментарий 5", :org_id => 1, :user_id => 5, :user => user, :created_at => DateTime.new(2010, 01, 10, 10, 50, 00))
    @rewiews.stub(:total_entries).and_return(10)
    @rewiews.stub(:total_pages).and_return(2) 
    @rewiews.stub(:current_page).and_return(1)
    @rewiews.stub(:previous_page).and_return(0)  
    @rewiews.stub(:next_page).and_return(2)   
    
    assigns[:org] = @org
    assigns[:rewiews] = @rewiews
    
    render 'frontend/rewiews/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/rewiews.html")
    response.should have_tag('li#current', "Отзывы")
    response.should have_tag('div#rewiews div', :count => 6)  
    response.should have_tag('div.pagination')
    response.should have_tag('span.current', "1")
    response.should have_tag('a[rel=next]', "2")
    response.should have_tag('a.next_page', "Вперед &raquo;")
    response.should have_tag('form[action=?]', "/orgs/1/rewiews/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('textarea#rewiew_text') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять комментарии")
  end
   
  it "должна содержать сообщение, что отзывов нет и форму добавления комментария" do
    @rewiews.stub(:total_entries).and_return(0)
    @rewiews.stub(:total_pages).and_return(0)     
    
    assigns[:org] = @org
    assigns[:rewiews] = @rewiews
    
    render 'frontend/rewiews/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/rewiews.html")
    response.should have_tag('li#current', "Отзывы")
    response.should_not have_tag('div.pagination')
    response.should have_tag('p', "Нет отзывов, будь первым")
    response.should have_tag('form[action=?]', "/orgs/1/rewiews/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('textarea#rewiew_text') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять комментарии")
  end
end
