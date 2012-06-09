class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.references :org
      t.string :department
      t.string :number, :limit => 15
      t.timestamps
    end
    add_index :phones, :org_id
  end

  def self.down
    remove_index :phones, :org_id
    drop_table :phones
  end
end
