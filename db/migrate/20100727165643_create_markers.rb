class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.references :org
      t.string :name
      t.float :latitude
      t.float :longtitude
      t.timestamps
    end
    add_index :markers, :org_id
  end

  def self.down
    remove_index :markers, :org_id
    drop_table :markers
  end
end
