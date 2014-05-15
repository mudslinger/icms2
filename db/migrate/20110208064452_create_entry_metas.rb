class CreateEntryMetas < ActiveRecord::Migration
  def self.up
    create_table :entry_metas do |t|
      t.integer :entry_id, :null => false
      t.integer :field_id, :null => false
      t.string :string_value, :limit => 1024
      t.text :text_value
      t.integer :int_value
      t.date :date_value
      t.float :float_value
      t.string :file_value, :limit => 4096

      t.timestamps
    end
    add_index :entry_metas, [:entry_id, :field_id ], :unique => true
    
  end

  def self.down
    drop_table :entry_metas
  end
end
