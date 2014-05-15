class AddFormIndexToEntries < ActiveRecord::Migration
  def self.up
    add_index :entries, :form_id, :unique => false
  end

  def self.down
    drop_index :entries, :form_id
        
  end
end
