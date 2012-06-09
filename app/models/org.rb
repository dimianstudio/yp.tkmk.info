class Org < ActiveRecord::Base
  
  # Exceptions
  class RecordExist < Exception
    def message
      "Или вы не внесли никаких изменений, или такая организация уже существует"
    end
  end
  
  # Relations
  belongs_to :user
  belongs_to :town, :counter_cache => true
  belongs_to :street, :counter_cache => true
  
  has_many :phones, :dependent => :destroy
  has_many :images
  has_many :markers
  has_many :requests, :dependent => :destroy
  has_many :associations, :dependent => :destroy
  has_many :tags, :through => :associations
  has_many :activities, :dependent => :destroy
  has_many :categories, :through => :activities
  has_many :rewiews, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
  has_attached_file :image, :url => "/images/orgs/adv/:basename.:extension", :path => ":rails_root/../assets/yp/images/orgs/adv/:basename.:extension" 

  validates_attachment_size :image, :less_than => 1.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  # Sphinx indexes  
  define_index do
    indexes :name
    indexes :description
    indexes town.name
    indexes street.name
    indexes tags.name
    indexes phones.number  
  end
  
  # Validatiors
  email_name_regex  = '[\w\.%\+\-]+'.freeze
  domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  www_regex         = /^(http|https):\/\/#{domain_head_regex}#{domain_tld_regex}(\/)?\z/i
  
  # TODO: проверка на вхождение в массив городов и улиц
  
  validates_presence_of :name, :user_id, :town_id, :street_id
  validates_numericality_of :user_id, :town_id, :street_id
  validates_numericality_of :house, :allow_nil => true, :unless => Proc.new { |org| org.house == "" }
  validates_length_of :email, :within => 6..100, :allow_nil => true, :unless => Proc.new { |org| org.email == "" }
  validates_format_of :email, :with => email_regex, :allow_nil => true, :unless => Proc.new { |org| org.email == "" }
  validates_length_of :www, :within => 4..256, :allow_nil => true, :unless => Proc.new { |org| org.www == "" }
  validates_format_of :www, :with => www_regex, :allow_nil => true, :unless => Proc.new { |org| org.www == "" }
  
  # Metods  
  def self.check(org)
    if self.find(:first, :conditions => org)
      raise Org::RecordExist
    end      
  end
end
