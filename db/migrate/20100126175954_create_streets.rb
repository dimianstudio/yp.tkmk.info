class CreateStreets < ActiveRecord::Migration
  def self.up
    create_table :streets do |t|
      t.string :name, :limit => 50
      t.integer :orgs_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :streets
  end
end
