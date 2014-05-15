#coding:utf-8
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
Form.transaction do
  frm = Form.where(:template_name => "akiya_bank").first
  fields.each{|field|
    f = frm.fields.where(:name => field).first
    #puts "#{field}_title"
    puts f.label
    f2 = Field.new
    f2.name = "#{field}_title"
    f2.label = "#{f.label}タイトル"
    f2.form_id = frm.id
    f2.ftype = "text"
    f2.sortkey = sprintf( "%04d", f.sortkey.to_i + 1)
    f2.save!
  }
  
end