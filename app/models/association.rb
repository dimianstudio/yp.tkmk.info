class Association < ActiveRecord::Base
 
  # Relations
  belongs_to :user
  belongs_to :org
  belongs_to :tag
  
  # Validators
  validates_presence_of :user_id, :org_id, :tag_id
  validates_numericality_of :user_id, :org_id, :tag_id 
  
  def self.find_or_add(org, tag, user)
    self.find(:first, :conditions => ["org_id = ? AND tag_id = ?", org, tag]) || self.create!(:org_id => org, :tag_id => tag, :user_id => user)
  end
end
