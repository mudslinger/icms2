frm = Form.where("template_name =? ", "shop").first
Entry.transaction do
  Entry.where("form_id=?", frm.id).order("id").each do |entry|
    entry.cf.name = ""
    entry.cf.save_cached!
  end

end