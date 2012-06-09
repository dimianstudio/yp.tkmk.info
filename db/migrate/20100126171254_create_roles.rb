class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
      t.integer :rights_count, :default => 0
    end
  end

  def self.down
    drop_table "roles"
  end
end