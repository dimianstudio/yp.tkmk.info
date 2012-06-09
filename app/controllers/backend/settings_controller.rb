class Backend::SettingsController < BackendController

  def index
    @settings = APP_CONFIG
  end
  
  def update
    File.open( "#{RAILS_ROOT}/config/config.yml", 'w' ) do |out|
      YAML.dump( params[:setting], out )
    end
    redirect_to backend_settings_path
  end
end
