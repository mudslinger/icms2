class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.integer :created_by_id, :null => false
      t.integer :updated_by_id, :null => false
      t.integer :entry_id
      t.string :libtype
      t.string :label
      t.string :description
      t.string :file_name
      t.string :file_name_ext
      t.string :file_path
      t.string :content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :libraries
  end
end
