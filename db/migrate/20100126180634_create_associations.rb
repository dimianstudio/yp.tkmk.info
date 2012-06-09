class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations, :id => false do |t|
      t.references :org
      t.references :tag
      t.references :user
      t.timestamps
    end
    add_index :associations, :org_id
    add_index :associations, :tag_id
    add_index :associations, :user_id
  end

  def self.down
    remove_index :associations, :user_id
    remove_index :associations, :tag_id
    remove_index :associations, :org_id
    drop_table :associations
  end
end
