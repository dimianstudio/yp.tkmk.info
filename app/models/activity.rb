class Activity < ActiveRecord::Base
  
  # Exeptions
  class RecordNotFound < Exception
    def message
      "Такого вида деятельности нет"
    end
  end

  # Relations
  belongs_to :org
  belongs_to :category
  
  # Validatiors
  validates_presence_of :org_id, :category_id
  validates_numericality_of :org_id, :category_id
  
  def self.add(org, category)
    unless self.exists?(:org_id => org, :category_id => category)
      item = self.create!(:org_id => org, :category_id => category)
    end
  end
  
  def self.get(org, category)
    item = self.find(:first, :conditions => ["org_id = ? AND category_id = ?", org, category]).category
    if item == nil
      raise Activity::RecordNotFound
    else
      item
    end
  end
end
