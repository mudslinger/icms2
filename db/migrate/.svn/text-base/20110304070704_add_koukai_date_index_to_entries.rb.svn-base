class AddKoukaiDateIndexToEntries < ActiveRecord::Migration
  def self.up
    add_index :entries, :date_begin, :unique => false
    add_index :entries, :date_end, :unique => false
  end

  def self.down
    drop_index :entries, :date_begin
    drop_index :entries, :date_end    
  end
end
