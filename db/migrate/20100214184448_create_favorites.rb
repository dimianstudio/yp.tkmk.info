class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites, :id => false do |t|
      t.references :org
      t.references :user
      t.timestamps
    end
    add_index :favorites, :org_id
    add_index :favorites, :user_id
  end

  def self.down
    remove_index :favorites, :user_id
    remove_index :favorites, :org_id
    drop_table :favorites
  end
end
