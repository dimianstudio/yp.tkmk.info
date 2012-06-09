class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :limit => 30
      t.references :user
      t.timestamps
    end
    add_index :tags, :user_id
  end

  def self.down
    remove_index :tags, :user_id
    drop_table :tags
  end
end
