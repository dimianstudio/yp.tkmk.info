class Request < ActiveRecord::Base
  serialize :content
  
  class NoRequiredFields < Exception
    def message
      "Следует заполнить обязательные поля"
    end
  end
  
  # Relations
  belongs_to :org
  belongs_to :user
  
  # TODO: Пользователь не может добавить в один день более 5 запросов - сделать это
  def self.add(org_id, user, object, action, content)
    self.create!(
      :org_id       => org_id,
      :user_id      => user.id,
      :object       => object,
      :action       => action,
      :content      => content
    )
  end

  def approval(comment, approved)
    self.comment = comment
    self.approved = approved
    self.save!
  end
end
