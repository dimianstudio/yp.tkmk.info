class Image < ActiveRecord::Base
  
  # Exceptions
  class NoRequiredFields < Exception
    def message
      "Выберите файл для загрузки"
    end
  end
  
  has_attached_file :image, :styles => { :small => "217x150#" },  :url => "/images/orgs/:style/:basename.:extension", :path => ":rails_root/../assets/yp/images/orgs/:style/:basename.:extension" 
  
  # Relations
  belongs_to :org
  
  # Validators
  # validates_presence_of :org_id, :number
  validates_attachment_size :image, :less_than => 1.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
end
