class Marker < ActiveRecord::Base
  
  # Exceptions
  class NoRequiredFields < Exception
    def message
      "Выберите точку на карте"
    end
  end
  
  # Relations
  belongs_to :org
end
