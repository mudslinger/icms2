# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
user = User.new
user.login = 'admin'
user.name = 'admin'
user.user_level = 3
user.password = 'admin'
user.password_confirmation = 'admin'
user.save!


ac = AppConfig.new
ac.cron1_triggered_at = Time.now
ac.save!