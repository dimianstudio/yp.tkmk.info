class Tag < ActiveRecord::Base
  
  # Exceptions
  class NoRequiredFields < Exception
    def message
      "Введите хоть что-то"
    end
  end
  
  # Relations
  has_many :associations, :dependent => :destroy
  has_many :orgs, :through => :associations
  belongs_to :user
  
  # Validators
  validates_presence_of :name

  # Metods
  def self.find_or_add(tag,user)
    self.find(:first, :conditions => ["name = ?", tag]) || self.create!(:name => tag, :user_id => user)
  end
  
  def self.cloud(count)
    tags = Association.count(:all, :group => 'tag_id').sort{ |a,b| b[1]<=>a[1] }
    result = []
    tags[0..count].each do |tag|
      result << { :name => self.find(tag[0]).name, :id => tag[0] }
    end
    result
  end
end
