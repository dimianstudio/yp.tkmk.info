class Category < ActiveRecord::Base
  acts_as_tree :order => 'name'
  
  # Exceptions
  class NotZero < Exception
  end
  
  # Relations
  has_many :activities
  has_many :orgs, :through => :activities
  
  # Validators
  validates_presence_of :parent_id, :name
  validates_numericality_of :parent_id
  
  def self.get_parent_categories
    self.root.children
  end
  
  def self.count_parent_categories
    self.root.children.size
  end
  
  def self.get_subcategories_of_first_category
    categories = self.get_parent_categories
    categories[0].children
  end
end
