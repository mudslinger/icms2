fields = %w(pic_main
pic_small1
pic_small2
pic_small3
pic_small4
pic_small5
pic_small6
pic_small7
pic_small8
pic_small9
pic_small10
pic_small11
pic_small12
pic_small13
pic_small14
pic_small15
pic_small16
pic_madori
pic_gairyaku
)


Entry.transaction do

Entry.where(:form_id => 10).each do |e|
  
  fields.each do |f|
    pic = e._cf(f)
    if pic
      unless pic.blank?
        puts "#{pic}"
        pic.recreate_versions!
      end
    end
  
  end
  
end



end