class Rewiew < ActiveRecord::Base
  
  # Exceptions
  class RecordExist < Exception
    def message
      "Вы уже оставляли такой отзыв"
    end
  end
  
  class NoRequiredFields < Exception
    def message
      "Следует написать хоть какие-то слова ;)"
    end
  end
  
  # Relations
  belongs_to :org
  belongs_to :user
  
  #Validations
  validates_presence_of :text, :org_id, :user_id
  validates_numericality_of :org_id, :user_id     
  
  # Metods
  def self.add!(org, user, text) 
    self.find!(org, user, text) || self.create!( :user_id => user, :org_id => org, :text => text)
  end  
  
  def self.find!(org, user, text) 
    if self.find(:first, :conditions => ["text = ? AND org_id = ? AND user_id = ?", text, org, user])
      raise Rewiew::RecordExist
    else
      false
    end      
  end
end
