class Town < ActiveRecord::Base
  
  # Relations
  has_many :orgs
  
  # Validators
  validates_presence_of :name
  validates_length_of :name, :within => 3..50
  validates_uniqueness_of :name
end
