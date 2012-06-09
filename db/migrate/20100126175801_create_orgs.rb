class CreateOrgs < ActiveRecord::Migration
  def self.up
    create_table :orgs do |t|
      t.string :name
      t.text :description
      t.references :user
      t.references :town
      t.references :street
      t.string :house, :limit => 10
      t.string :email
      t.string :www
      t.boolean :recommended
      t.timestamps
      t.string :image_link
    end
    add_index :orgs, :user_id
    add_index :orgs, :town_id
    add_index :orgs, :street_id
  end

  def self.down
    remove_index :orgs, :street_id
    remove_index :orgs, :town_id
    remove_index :orgs, :user_id
    drop_table :orgs
  end
end
