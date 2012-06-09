require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
  
describe "Страница удаления телефона" do
  
  it "должна содержать форму для удаления телефона и блок с информацией для удаления" do
    org = mock_model(Org, :id => 1, :name => "Организация", :user_id => 1, :town_id => 2, :street_id => 15, :house => 45)
    activity = mock_model(Category, :id => 3, :parent_id => 2, :name => "Категория") 
    Org.stub(:find).and_return(org)    
    Activity.stub(:get).and_return(activity)
    
    assigns[:org] = org
    assigns[:activity] = activity
    
    render 'frontend/activities/destroy'
    
    response.should have_tag('h2', "Организация")
    response.should have_tag('li#current a[href=?]', "/orgs/1/activities.html")
    response.should have_tag('li#current', "Виды деятельности")
    response.should have_tag('h3', "Удалить вид деятельности")
    response.should have_tag('div.remove-info')
    response.should have_tag('div.remove-info p strong', :count => 1)
    response.should have_tag('div.remove-info p', "Название организации: Организация")
    response.should have_tag('div.remove-info p', "Вид деятельности: Категория")
    response.should have_tag('form[action=?]', "/orgs/1/activities/3/delete.html")
    response.should have_tag('form[method=?]', "post") 
    response.should have_tag('input[name=_method][value=?]', "delete") 
    response.should have_tag('div.required textarea#request_msg')
    response.should have_tag('input.button[value=?]', "Удалить")
  end
end
