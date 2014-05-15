class CreateAppConfigs < ActiveRecord::Migration
  def self.up
    create_table :app_configs do |t|
      t.datetime :cron1_triggered_at

      t.timestamps
    end
  end

  def self.down
    drop_table :app_configs
  end
end
