task "hogehoge" do
  
  puts "hi there."
  system "mysqldump -h vmg10.dmz1.izumo.ne.jp -uwebadmin --password='nXyiB8H2' icms_production | mysql -uroot icms_development "
  
end


task "init_app_confg_data" do

  if AppConfig.all.size == 0
    ac = AppConfig.new
    ac.cron1_triggered_at = round_sec( Time.now)
    ac.save
  end
  
end


task "logrotate_config" do
  warn "put below to /etc/logrotate.d/rails"
  puts <<-EOF
#{Rails.root}/*log {
    missingok
    notifempty
    sharedscripts
    compress
    postrotate
        /bin/touch #{Rails.root}/tmp/restart.txt
    endscript
}
  
  EOF
  

end


task "cron_config" do
  puts <<-EOF
MAILTO=logger@izumo.ne.jp
*/15 * * * * #{Rails.root}/lib/tasks/sweep_cache_trigger.sh  
  EOF
end

task "sample_template" do
  files = Dir.glob( File.join(Rails.root, "doc", "default_template", "*"))
  FileUtils.cp_r files, File.join(Rails.root, "app/views/contents"), {:noop => false, :verbose => true}
end