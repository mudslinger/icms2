class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.text :content
      t.text :memo
      t.integer :form_id
      t.integer :created_by_id, :null => false
      t.integer :updated_by_id, :null => false
      t.datetime :date_begin
      t.datetime :date_end
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
