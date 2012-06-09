class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.references :org
      t.references :category
      t.timestamps
    end
    add_index :activities, :org_id
    add_index :activities, :category_id
  end

  def self.down
    remove_index :activities, :category_id
    remove_index :activities, :org_id
    drop_table :activities
  end
end
