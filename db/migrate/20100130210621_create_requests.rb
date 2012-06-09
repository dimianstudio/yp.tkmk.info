class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.references :user
      t.references :org
      t.string :object
      t.string :action
      t.text :content
      t.text :comment
      t.boolean :approved
      t.timestamps
    end
    
    add_index :requests, :user_id
    add_index :requests, :org_id
    
  end

  def self.down
    remove_index :requests, :org_id
    remove_index :requests, :user_id
    drop_table :requests
  end
end
