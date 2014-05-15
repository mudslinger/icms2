def round_sec(tm)
  Time.mktime(tm.year, tm.month, tm.day, tm.hour, tm.min, 0)
  
end


  if AppConfig.all.size == 0
    ac = AppConfig.new
    ac.cron1_triggered_at = round_sec( Time.now)
    ac.save
  end
  