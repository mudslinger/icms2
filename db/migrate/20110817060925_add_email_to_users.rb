class AddEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :emailaddress, :string
  end

  def self.down
    remove_column  :users, :emailaddress
  end
end
