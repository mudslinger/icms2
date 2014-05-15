def attributes_for_copy(record)
  attr = record.attributes
  attr.delete("id")
  attr.delete("created_at")
  attr
end



Entry.transaction do
  
  frm = Form.where("template_name=?", "genki_kigyou").first
  frm2 = Form.where("template_name=?", "sangyou").first
  
  Entry.where("form_id=?", frm.id).each{|org_entry|
    warn "記事のコピー:#{org_entry.title}"
    attr = attributes_for_copy(org_entry)
    entry = Entry.new(attr)
    entry.form_id = frm2.id
    entry.save!
    org_entry.entry_metas.each{|org_em|
      if org_em.field.ftype == "image"
        warn "スキップ#{org_em.field.name}"
      else
        warn "フィールドこぴー#{org_em.field.name}"
        attr = attributes_for_copy(org_em)
        em = EntryMeta.new(attr)
        entry.entry_metas << em
      end
      
    }
    
  }
  
end
