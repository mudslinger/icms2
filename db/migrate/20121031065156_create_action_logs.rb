class CreateActionLogs < ActiveRecord::Migration
  def change
    create_table :action_logs do |t|
      t.string :name
      t.text :message

      t.timestamps
    end
  end
end
