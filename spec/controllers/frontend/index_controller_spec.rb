require "#{File.dirname(__FILE__)}/../../spec_helper.rb"

describe Frontend::IndexController do
  
  it "should GET/ index" do
    get :index, :format => "html"
    response.should render_template("index.html.haml")  
    lambda { get :index, :format => "html" }.should cache_page("/")
  end

end
