require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница тэгов" do
  
  before(:each) do
    @org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    Org.stub(:find).and_return(@org)
    @tags = []
  end
  
  it "должна содержать список тэгов и форму добавления тэгов" do
    5.times do |i|
      @tags << mock_model(Tag, :id => i, :name => "Тэг #{i}", :user_id => 1)
    end
    @org.stub(:tags).and_return(@tags)

    assigns[:org] = @org
    assigns[:tags] = @tags
    
    render 'frontend/tags/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/tags.html")
    response.should have_tag('li#current', "Тэги")
    response.should have_tag('div.tags a', :count => 5)
    response.should have_tag('div.tags a[href=/tag/1.html]', "Тэг 1")
    response.should have_tag('form[action=?]', "/orgs/1/tags/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('textarea#tag_string') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять, редактировать или удалять тэги")
  end
 
  it "должна содержать сообщение, что тэгов нет и форму добавления тегов" do
    assigns[:org] = @org
    assigns[:tags] = @tags
    
    render 'frontend/tags/index'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/tags.html")
    response.should have_tag('li#current', "Тэги")
    response.should have_tag('p', "Пока организация не имеет тэгов, но ты можешь изменить это ...")
    response.should have_tag('form[action=?]', "/orgs/1/tags/create.html")
    response.should have_tag('form[method=?]', "post")   
    response.should have_tag('textarea#tag_string') 
    response.should have_tag('input.button[value=?]', "Добавить")
    response.should have_tag('div.guest_area div.auth_notice', "Авторизуйтесь чтобы добавлять, редактировать или удалять тэги")
  end
end
