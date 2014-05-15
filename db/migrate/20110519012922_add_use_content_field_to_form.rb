class AddUseContentFieldToForm < ActiveRecord::Migration
  def self.up
    add_column :forms, :use_content_field, :boolean, :default => true        
  end

  def self.down
    remove_column :forms,:use_content_field
  end
end
