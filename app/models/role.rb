class Role < ActiveRecord::Base
 
  unloadable
  
  # Relations
  has_many :rights
  has_many :users, :through => :rights
  
  # Validators
  validates_presence_of :name
  validates_length_of :name, :within => 3..50
  validates_uniqueness_of :name
end