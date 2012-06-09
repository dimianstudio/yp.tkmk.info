class CreateRewiews < ActiveRecord::Migration
  def self.up
    create_table :rewiews do |t|
      t.text :text
      t.references :org
      t.references :user
      t.timestamps
    end
    add_index :rewiews, :org_id
    add_index :rewiews, :user_id
  end

  def self.down
    remove_index :rewiews, :user_id
    remove_index :rewiews, :org_id
    drop_table :rewiews
  end
end
