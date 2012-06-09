class Favorite < ActiveRecord::Base
  
  # Exceptions
  class RecordExist < Exception
    def message
      "Такая запись уже есть"
    end
  end
  
  # Relations
  belongs_to :user
  belongs_to :org
  
  # Validators
  validates_presence_of :org_id, :user_id
  validates_numericality_of :org_id, :user_id
  
  # Metods
  def self.add!(org,user)
    self.find!( org, user ) || self.create!( :org_id => org, :user_id => user )
  end
  
  def self.find!(org, user)
    raise Favorite::RecordExist if self.find( :first, :conditions => ["org_id = ? AND user_id = ?", org, user] )   
  end
end
