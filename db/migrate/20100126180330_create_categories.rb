class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id
      t.string :name, :limit => 60, :default => ""
      t.timestamps
    end
    add_index :categories, :parent_id
  end

  def self.down
    remove_index :categories, :parent_id
    drop_table :categories
  end
end
