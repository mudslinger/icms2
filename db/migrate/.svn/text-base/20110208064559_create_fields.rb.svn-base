class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :name, :null => false
      t.string :label
      t.text :description
      t.integer :form_id
      t.integer :required
      t.string :default
      t.string :ftype
      t.string :options
      t.string :sortkey

      t.timestamps
    end
    add_index :fields, [:form_id, :name ], :unique => true
  end

  def self.down
    drop_table :fields
  end
end
