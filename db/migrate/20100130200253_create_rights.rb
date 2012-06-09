class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights do |t|
      t.references :role
      t.references :user
      t.timestamps
    end
    
    add_index :rights, :role_id
    add_index :rights, :user_id
    
  end

  def self.down
    remove_index :rights, :user_id
    remove_index :rights, :role_id
    drop_table :rights
  end
end
