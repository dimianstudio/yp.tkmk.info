class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.references :from
      t.references :to
      t.string :title, :default => "Нет названия"
      t.text :body
      t.boolean :read
      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end
