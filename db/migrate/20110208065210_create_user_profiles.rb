class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.string :nickname
      t.string :email
      t.string :address
      t.string :avatar
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
