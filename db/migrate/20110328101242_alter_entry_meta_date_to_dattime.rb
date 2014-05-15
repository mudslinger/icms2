class AlterEntryMetaDateToDattime < ActiveRecord::Migration
  def self.up
    remove_column :entry_metas,:date_value
    add_column :entry_metas, :date_value, :datetime    
  end

  def self.down
    remove_column :entry_metas,:date_value
    add_column :entry_metas, :date_value, :date    
  end
end
