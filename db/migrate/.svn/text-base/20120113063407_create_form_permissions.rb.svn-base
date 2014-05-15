class CreateFormPermissions < ActiveRecord::Migration
  def self.up
    create_table :form_permissions do |t|
       t.integer :form_id, :null => false
       t.integer :user_id, :null => false
     
       t.timestamps
    end
    add_index :form_permissions, :form_id, :unique => false
    add_index :form_permissions, :user_id, :unique => false
  end

  def self.down
    drop_table :form_permissions
  end
end
