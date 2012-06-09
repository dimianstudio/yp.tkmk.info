require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Список организаций по тэгу" do
  
  before(:each) do
    @tag = mock_model(Tag, :id => 1, :name => "Тэг", :user_id => 1)
    Tag.stub(:find).and_return(@tag)
    @orgs = []
  end
  
  it "должен содержать список организаций ассоциированные с данным тэгом, без списка страниц" do
    8.times do |i| 
      @orgs << mock_model(Org, :id => i, :name => "Организация #{i}", :user_id => 1, :town => mock_model(Town, :id => 1, :name => "Город"),  :street => mock_model(Street, :id => 1+i, :name => "Улица #{i}"), :house => 45+i, :email => "", :www => "", :description => "") 
    end
    @tag.stub(:orgs).and_return(@orgs)
    
    @orgs.stub(:total_entries).and_return(8)
    @orgs.stub(:total_pages).and_return(0)

    assigns[:orgs] = @orgs
    assigns[:tag] = @tag
    
    render 'frontend/tags/show'
    
    response.should have_tag('h2', "Тэг &#8594; Тэг")
    response.should have_tag('p', "Найдено 8 организаций")
    response.should have_tag('div.org-box', :count => 8)
    response.should_not have_tag('div.pagination')
  end
  
  it "должен содержать список организаций ассоциированные с данным тэгом, а также список страниц" do
    10.times do |i| 
      @orgs << mock_model(Org, :id => i, :name => "Организация #{i}", :user_id => 1, :town => mock_model(Town, :id => 1, :name => "Город"),  :street => mock_model(Street, :id => 1+i, :name => "Улица #{i}"), :house => 45+i, :email => "", :www => "", :description => "") 
    end
    @tag.stub(:orgs).and_return(@orgs)
    
    @orgs.stub(:total_entries).and_return(15)
    @orgs.stub(:total_pages).and_return(2)
    @orgs.stub(:current_page).and_return(1)
    @orgs.stub(:previous_page).and_return(0)  
    @orgs.stub(:next_page).and_return(2)

    assigns[:orgs] = @orgs
    assigns[:tag] = @tag
    
    render 'frontend/tags/show'
    
    response.should have_tag('h2', "Тэг &#8594; Тэг")
    response.should have_tag('p', "Найдено 15 организаций")
    response.should have_tag('div.org-box', :count => 10)
    response.should have_tag('div.pagination')
    response.should have_tag('span.current', "1")
    response.should have_tag('a[rel=next]', "2")
    response.should have_tag('a.next_page', "Вперед &raquo;")
  end
 
  it "должен содержать сообщение, что организаций ассоциированных с данным тэгом нет" do
    assigns[:orgs] = @orgs
    assigns[:tag] = @tag
    
    @orgs.stub(:total_entries).and_return(0)
    @orgs.stub(:total_pages).and_return(0)
    
    render 'frontend/tags/show'
    
    response.should have_tag('h2', "Тэг &#8594; Тэг")
    response.should have_tag('p', "Этому тэгу не ассоциирована ни одна организация")
    response.should_not have_tag('div.pagination')
  end
end
