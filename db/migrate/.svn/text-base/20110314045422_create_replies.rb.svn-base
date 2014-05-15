class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.string :title
      t.text :content
      t.text :memo
      t.integer :entry_id
      t.integer :form_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.string :mailaddress
      t.string :ipaddress
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
