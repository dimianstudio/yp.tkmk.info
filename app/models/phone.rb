class Phone < ActiveRecord::Base 
  
  # Relations
  belongs_to :org
  
  # Validators
  validates_presence_of :org_id, :number
  validates_numericality_of :org_id, :number
  validates_length_of :number, :within => 3..11
end
