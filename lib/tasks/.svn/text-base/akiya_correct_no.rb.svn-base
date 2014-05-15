def zenkaku_to_hankaku(value)
  value.tr('０-９', '0-9')
end

frm = Form.where("template_name =? ", "akiya_bank").first
Entry.transaction do
  Entry.where("form_id=?", frm.id).each do |entry|
    hankaku_no = zenkaku_to_hankaku(entry.cf.no)
    puts entry.title + ", no= " + entry.cf.no + ", han=#{hankaku_no}"
    entry.cf.no = sprintf("%02d", hankaku_no.to_i)
    entry.cf.save_cached!
    
  end

end