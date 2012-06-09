class UserBaseConnection < ActiveRecord::Base
  establish_connection(ActiveRecord::Base.configurations["users_#{RAILS_ENV}"])
  self.abstract_class = true
end
