class Object
  def metaclass; class << self; self; end end
end

class Hash
  def to_obj
    hash = self
    metaclass.class_eval do
      hash.each_pair do |key, value|
        define_method key do
          value
        end
      end
    end
  end
end

class Backend::RequestsController < BackendController
  
  # Filters
  before_filter :init_org, :only => :show
  
  # GET /backend/requests.html -------------------------------------- HTML
  def index
    @requests = Request.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end  
  
  # GET /backend/orgs/1/requests.html ------------------------------- HTML
  def show
    @requests = @org.requests.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  # GET /backend/requests/1/edit.html ------------------------------- HTML
  def edit    
    @request = Request.find(params[:id])
    case @request.object
      when "org" then
        case @request.action
          when "add" then 
            @org = @request.content[:new_record][:org].to_obj
            @phones = @request.content[:new_record][:phones]
            @activities = @request.content[:new_record][:activities]
            render :template => "backend/requests/templates/org_add"
          when "edit" then 
            @org_editable = @request.content[:edit_record].to_hash.to_obj
            render :template => "backend/requests/templates/org_edit"
          when "delete" then
            @org = Org.find(@request.content[:delete_record_id]) 
            render :template => "backend/requests/templates/org_delete"
        end
      when "phone" then
        case @request.action
          when "add" then
            @phones = @request.content[:phones]
            render :template => "backend/requests/templates/phone_add"
          when "edit" then
            @phone = Phone.find(@request.content[:original_record_id])  
            @phone_editable = @request.content[:edit_record].to_obj
            render :template => "backend/requests/templates/phone_edit"            
          when "delete" then
            @phone = Phone.find(@request.content[:delete_record_id]) 
            render :template => "backend/requests/templates/phone_delete"  
        end
      when "activity" then
        case @request.action
          when "add" then
            @activities = @request.content[:new_record]
            render :template => "backend/requests/templates/activity_add"
          when "delete" then
            @activity = Category.find(@request.content[:delete_record_id]) 
            render :template => "backend/requests/templates/activity_delete"
        end
    end
    session[:back] = request.env["HTTP_REFERER"]  
  rescue ActiveRecord::RecordNotFound => e
    respond_error "Наверное объект запроса уже удален"
  rescue
    respond_error
  end
  
  # PUT /backend/requests/1.html ------------------------------------ HTML
  def update  
    @request = Request.find(params[:id])
    unless params[:request][:comment].blank?
      unless @request.approved
        if params[:request][:approved] == "1"
          case @request.object
            when "org" then
              case @request.action
                when "add" then
                  Org.transaction do
                    @org = Org.create!(
                      :name         => params[:org][:name],
                      :description  => params[:org][:description],
                      :user_id      => @request.user_id,
                      :town_id      => params[:org][:town_id],
                      :street_id    => params[:org][:street_id],
                      :house        => params[:org][:house],
                      :email        => params[:org][:email],
                      :www          => params[:org][:www]
                    )                    
                    if params[:activities]
                      params[:activities].each do |activity|
                        Activity.create(
                          :org_id      => @org.id,
                          :category_id => activity
                        )
                      end
                    end                    
                    unless params[:phones].empty?
                      params[:phones].each do |phone|
                        Phone.create(
                          :org_id     => @org.id,
                          :department => phone[:department],
                          :number     => phone[:number]
                        )                      
                      end
                    end
                    expire_cache_org(@org.id)
                  end
                when "edit" then 
                  @org = Org.find(@request.org_id)
                  @org.update_attributes!(params[:org_editable]) 
                  expire_cache_org(@request.org_id)                
                when "delete" then
                  expire_cache_org(@request.org_id)
                  Org.destroy(@request.org_id)                  
              end
            when "phone" then
              case @request.action
                when "add" then                  
                  unless params[:phones].empty?
                    params[:phones].each do |phone|
                      Phone.create(
                        :org_id     => @request.org_id,
                        :department => phone[:department],
                        :number     => phone[:number]
                      )                      
                    end
                  end
                  expire_cache_phones(@request.org_id)
                when "edit" then
                  phone = Phone.find(@request.content[:original_record_id]) 
                  phone.update_attributes!(params[:phone_editable]) 
                  expire_cache_phones(@request.org_id)            
                when "delete" then
                  expire_cache_phones(@request.org_id)
                  Phone.destroy(@request.content[:delete_record_id]) 
              end
            when "activity" then
              case @request.action
                when "add" then
                  params[:activities].each do |activity|
                    Activity.create(
                      :org_id      => @request.org_id,
                      :category_id => activity
                    )
                    expire_cache_activities(@request.org_id)
                  end
                when "delete" then
                  expire_cache_activities(@request.org_id)
                  Activity.delete_all(['org_id = ? AND category_id = ?', @request.org_id, @request.content[:delete_record_id]])
              end
          end
          @request.approval(params[:request][:comment], params[:request][:approved])
          respond_success "Запрос успешно обработан", session[:back]
        else
          @request.approval(params[:request][:comment], params[:request][:approved])
          respond_success "Запрос не обработан"
        end 
      else
        @request.approval(params[:request][:comment], params[:request][:approved])
        respond_success "Данные запроса успешно изменены"
      end     
    else
      respond_error "Введите комментарий к запросу"
    end
  rescue
    respond_error
  end
  
  # DELETE /backend/requests/1.html --------------------------------- HTML
  def destroy
    Request.delete(params[:id])
    respond_success "Запрос успешно удален"     
  rescue
    respond_error
  end
  
private

  def init_org
    @org = Org.find(params[:id])
  end 
  
  def expire_cache_org(id)
    org = Org.find(id)
    expire_file("orgs/#{id}.html")
    expire_dirs("orgs/#{id}/")
    org.categories.collect{ |c| [c.id] }.each do |category|
      expire_files("categories/#{category}.html") 
      expire_dirs("categories/#{category}/")
    end
    org.tags.collect{ |t| [t.id] }.each do |tag|
      expire_files("tag/#{tag}.html") 
      expire_dirs("tag/#{tag}/")
    end
  end
  
  def expire_cache_phones(id)
    expire_files("orgs/#{id}/phones.html") 
    expire_dirs("orgs/#{id}/phones/")
  end
  
  def expire_cache_activities(id)
    org = Org.find(id)
    expire_file("orgs/#{id}.html")
    expire_files("orgs/#{id}/activities.html") 
    org.categories.collect{ |c| [c.id] }.each do |category|
      expire_files("categories/#{category}.html") 
      expire_dirs("categories/#{category}/")
    end
  end
end