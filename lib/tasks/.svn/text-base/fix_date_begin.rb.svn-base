frm = Form.where("template_name =? ", "shop").first
Entry.transaction do
  Entry.where("form_id=?", frm.id).order("id").each do |entry|
    entry.date_begin = Time.mktime(2011, 8, 15, 12, 0)
    puts entry.title
    entry.save!
  end

end