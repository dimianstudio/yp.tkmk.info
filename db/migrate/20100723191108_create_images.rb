class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :org
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
    add_index :images, :org_id
  end

  def self.down
    remove_index :images, :org_id
    drop_table :images
  end
end
