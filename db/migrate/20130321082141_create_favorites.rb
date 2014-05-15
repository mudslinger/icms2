class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id, :null => false
      t.integer :entry_id, :null => false

      t.timestamps
    end
    add_index :favorites, [:user_id, :entry_id], :unique => true
  end
end
