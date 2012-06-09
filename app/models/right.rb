class Right < ActiveRecord::Base
  
  # Relations
  belongs_to :user
  belongs_to :role, :counter_cache => true
end
