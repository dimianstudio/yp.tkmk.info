class Backend::InboxController < BackendController

  def index
    @mails = Mail.find(:all, :order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def destroy
    Mail.destroy(params[:id])
    output_success("Письмо успешно удалено")    
  rescue
    output_failure
  end
  
  def output_success(msg)
    flash[:notice] = msg
    redirect_to :back
  end
  
  def output_failure(msg = "Извините, произошла ошибка!!!")
    flash[:error] = msg
    redirect_to :back
  end
  
end
