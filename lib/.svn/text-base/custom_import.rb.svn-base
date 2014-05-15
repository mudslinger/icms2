#coding:utf-8
class CustomImport
  
  def import(name, file, current_user)
    case name
      when "some_category"
        import_job(file, current_user)
      when "jyuutaku_category"
        import_jyuutaku(name, file, current_user)
      when "category_of_shop"
        import_shop(name, file, current_user)
      else
        import_common(name, file, current_user)
    end
    
  end
  
  
  def import_common(name, file, current_user)
    form = Form.where(:template_name => name).first
    rownum = 0
    fnames = []
    Entry.transaction do
      #エンコーディングが勝手に変換されるのを防ぐ
      CSV.foreach(file.path, :encoding => "Windows-31J:Windows-31J") do |row|
        rownum += 1
        row = row.map{|r| r.to_s.encode "utf-8"}
        
        if rownum == 1
          fnames = row
         next 
        end
         
        
        entry = Entry.new
        hs = {}
        row.each_with_index{|ele,i|
          fname = fnames[i]
          if fname
            hs[fname] = ele
          end
        }
       
        
        if fnames.include? "title"
          entry.title = hs["title"]
        end
        if fnames.include? "content"
          entry.content = hs["content"]
        end
        
        
        
        p hs
        entry.form_id = form.id
        #掲載終了日は指定しない
        #entry.date_end = 1.years.from_now
        entry.created_by = entry.updated_by =  current_user
        entry.date_begin = Time.now
        
        #entry.status = "pending"
        entry.status = "publish"
        if entry.save && entry.save_entry_metas(:f => hs)
        else
          raise ActiveRecord::RecordInvalid, entry
        end
        
        
        
      end
    end      
  end
  
  #
  #店舗新規登録
  #
  def import_shop_initial(name, file, current_user)
    form = Form.where(:template_name => name).first
    rownum = 0
    fnames = []
    Entry.transaction do
      #エンコーディングが勝手に変換されるのを防ぐ
      #CSV.foreach(file.path, :encoding => "Windows-31J:Windows-31J") do |row|
      CSV.foreach(file.path) do |row|
        rownum += 1
puts "rownum=#{rownum}"
        #row = row.map{|r| r.to_s.encode "utf-8"}

        if rownum == 1
          fnames = row
         next
        end


        entry = Entry.new
        hs = {}
        row.each_with_index{|ele,i|
          fname = fnames[i]
          if fname
            hs[fname] = ele
          end
        }


        if fnames.include? "name"
          entry.title = hs["name"]
        end
        if fnames.include? "content"
          entry.content = hs["content"]
        end



        #p hs
        entry.form_id = form.id
        #entry.date_end = 1.years.from_now
        entry.created_by = entry.updated_by =  current_user

        #entry.status = "pending"
        entry.status = "publish"
        if entry.save && entry.save_entry_metas(:f => hs)
        else
          raise ActiveRecord::RecordInvalid, entry
        end



      end
    end
  end
  #
  #店舗
  #
  def import_shop(name, file, current_user)
    form = Form.where(:template_name => name).first
    rownum = 0
    fnames = []
    Entry.transaction do
      #エンコーディングが勝手に変換されるのを防ぐ
      #CSV.foreach(file.path, :encoding => "Windows-31J:Windows-31J") do |row|
        #↓csvがutf-8のとき
      CSV.foreach(file.path) do |row| 
        rownum += 1
#log "rownum=#{rownum}"

        #row = row.map{|r| r.to_s.encode "utf-8"}

        #先頭行
        if rownum == 1
          fnames = row
          fnames.map!{|ele| if ele ; ele.force_encoding "utf-8" ; end }
          p fnames
         next
        end


        entry = Entry.new
        hs = {}
        row.each_with_index{|ele,i|
          fname = fnames[i]
          if ele ; ele.force_encoding "utf-8" ; end
          
            hs[fname] = ele
          
        }




#puts hs["店舗名"]
p hs
        #p hs
        entry.form_id = form.id
        #entry.date_end = 1.years.from_now
        entry.date_begin = Time.mktime(2011, 10, 7, 12, 0)
        entry.created_by = entry.updated_by =  current_user

        #entry.status = "pending"
        entry.status = "publish"
        
        area_id  = begin
          area_name = hs["市町村"]
          area_name.sub!(/^[A-Z]_/, '')
          #area_form_id = Form.where(:template_name => "area").first.id
         obj = _headline("area", 1 , :where => "title='#{area_name}'").first
         if obj
           obj.cf.area_id
         else
            puts "no match for area '#{area_name}''"
            nil
         end
       end
        
        category_id = begin
          category_name = hs["業種１"]
          category_name.sub!(/^\d+）/,'')
          obj = _headline("category", 1 , :where => "title='#{category_name}'").first
          if obj
            obj.cf.cat_id
          else
              puts "no match for category '#{category_name}''"
            nil 
          end
       end
        
       raise "area_id不明" if area_id.blank?
       raise "category_id不明for#{category_name}" if category_id.blank?
        
        entry.title = hs["店舗名"]        
        entry.cf.status = "1"
        entry.cf.area = area_id
        entry.cf.category = category_id
        entry.cf.shop_id = hs["番号"]
        entry.cf.category2 = hs["業種２"]
        #entry.name = 
        entry.cf.postal = hs["〒"] 
        entry.cf.address = hs["住所"] 
        entry.cf.tel = hs["℡"]
        entry.cf.fax = hs["FAX"]
        entry.cf.url = hs["ホームページ"]
        entry.cf.time = hs["営業時間"]
        entry.cf.yasumi = hs["定休日"]
        entry.cf.service = hs["サービス内容"]
        entry.cf.gentei = hs["対象日の限定"]
        entry.cf.message = hs["お客様へのメッセージ"]
        


        flag = hs["フラグ"]

        if flag == "新規○" || flag == "○"
          
          touroku_flag = true
        else
          touroku_flag = false
        end
log "flag='#{flag}', touroku_flag=#{touroku_flag}"        


        old_shop = find_shop(entry.cf.shop_id)
        
        if touroku_flag
            
          if old_shop
            
             difference_exists = shop_different?(entry, old_shop)
             
           if difference_exists
             log "rownum=#{rownum}, operation=更新:#{difference_exists} :#{entry.title}"
              (old_shop.save && old_shop.cf.save_cached!) or raise ActiveRecord::RecordInvalid, old_shop
            else
              #中身が同じなので更新しない
              log "rownum=#{rownum}, operation=更新しない :#{entry.title}"
           end
          else
            log "rownum=#{rownum}, operation=新規 :#{entry.title}"
            (entry.save && entry.save_entry_metas(shop_cf(entry))) or raise ActiveRecord::RecordInvalid, entry
          end
        else
          if old_shop
              log "rownum=#{rownum}, operation=削除 :#{entry.title}"
              old_shop.destroy
          else
              log "rownum=#{rownum}, operation=無視 :#{entry.title}"
          end
        end
        

#        if entry.save && entry.save_entry_metas(:f => hs)
#        else
#          raise ActiveRecord::RecordInvalid, entry
#        end



      end
    end
  end  
  
  #
  #住宅
  #
  def import_jyuutaku(name, file, current_user)
    form = Form.where(:template_name => name).first

    Entry.transaction do
      entry = Entry.where(:form_id => form.id).first
      unless entry
        entry = Entry.new
        entry.form_id = form.id
        entry.date_end = nil
        entry.created_by = current_user
      end
      entry.updated_by =  current_user
      entry.status = "publish"
      
      #rows = self.class.csv2hash_array(file.path)
      
      #entry.content = YAML.dump(rows)
      #entry.cf.data = file
      
      if entry.save && entry.save_entry_metas(:f => {"data" => { "file_value"=> file}} ) 
      else
        raise ActiveRecord::RecordInvalid, entry
      end
      
    end           
  end
  
  def import_job(file)
      name = "job"
      form = Form.where(:template_name => name).first
      #logger.debug  "Encoding.default_internal=#{Encoding.default_internal},Encoding.default_external=#{Encoding.default_external}"
      #CSV.foreach(file.path, :encoding => "Windows-31J:BINARY") do |row|
      #fnames =  ["jigyousyomei", "syokusyu", "nenrei", "tingin", "kyujinsya", "syozaiti", "jikan", "hoken", "sikaku", "tekiyo", "homepage"]
      fnames =  [nil, "syokusyu", "nenrei", "tingin",  "kyujinsya","syozaiti",  "jikan",  "hoken", "sikaku",  "tekiyo"]
      rownum = 0
      Entry.transaction do
        #エンコーディングが勝手に変換されるのを防ぐ
        CSV.foreach(file.path, :encoding => "Windows-31J:Windows-31J") do |row|
          rownum += 1
          next if rownum == 1
          row = row.map{|r| r.to_s.encode "utf-8"}
          entry = Entry.new
          hs = {}
          row.each_with_index{|ele,i|
            fname = fnames[i]
            if fname
              hs[fname] = ele
            end
          }
          p hs
          entry.form_id = form.id
          entry.date_end = 1.years.from_now
          entry.created_by = entry.updated_by =  current_user
          entry.title = hs["kyujinsya"]
          entry.status = "pending"
          if entry.save && entry.save_entry_metas(:f => hs)
          else
            raise ActiveRecord::RecordInvalid, entry
          end
          
          
          
        end
      end    
  end
  
  def self.csv2hash_array(path)
      rows = []
    rownum = 0
    fnames = []      
      #エンコーディングが勝手に変換されるのを防ぐ
      CSV.foreach(path, :encoding => "Windows-31J:Windows-31J") do |row|
        rownum += 1
        row = row.map{|r| r.to_s.encode "utf-8"}
        
        if rownum == 1
          fnames = row
         next 
        end
         
        
        
        hs = {}
        row.each_with_index{|ele,i|
          fname = fnames[i]
          if fname
            hs[fname] = ele
          end
        }
        rows << hs
    end
    return rows
  end
  
  
  #
  #ヘッドライン
  #
  def _headline(name, per_page = 5, options = {})
    
    #:page -> :headline_pageメインのコンテンツのページ数と混同しないようにする
    #Entry.joins(:form).page(params[:headline_page]).per(per_page).order("updated_at DESC").
    #  where("forms.template_name =? ", name).where( Entry.sql_valid_article , now, now, now)  
    #クエリを単純にするためEntry.joins(:form)を使うのをやめ、クエリを２回に分ける 
    form = Form.where("template_name = ?", name).first
    entries = Entry.where("form_id =? ", form.id)
      

      
      
    unless options.empty?
      entries = Entry.cf_filter(entries, name, options)  
    end
      
    return entries
  end     
  
  def find_shop(shop_id)
    form = Form.where("template_name = ?", "shop").first
    entries = Entry.where("form_id =? ", form.id)
    entries = Entry.cf_filter(entries, "shop", :where => "{shop_id}=#{shop_id}")
    shop = entries.first
    if shop
      shop = Entry.find(shop.id)
    end
  end
  
  def shop_different?(shop, old_shop)
    fnames = ["status", "area", "category", "shop_id", "category2", 
    #"name", 
    "postal", 
    "address", "tel", 
    "fax", "url", "time", "yasumi", "service", "gentei", "message"]
    
    flag = false
    
    if (shop.title != old_shop.title)
      flag = true
      old_shop.title = shop.title 
    end
    
    
    fnames.each{|fname|
      v1 = shop._cf(fname)
      v2 = old_shop._cf(fname)
      if v1.blank? && v2.blank?
        
      else
        if v1 != v2
          #puts "#{fname}が違う#{v1} != #{v2}"          
          flag = true
          old_shop.cf.__send__("#{fname}=", shop._cf(fname))
        end
        
      end
    
    }
    flag
  end
  
  def shop_cf(entry)
names = %w(status
area
category
shop_id
category2
postal
address
tel
fax
url
time
yasumi
service
gentei
message)
    hs = {}
    names.each{|name|
      hs[name] = entry._cf(name)
    
    }
    ret = {:f => hs}
    p ret
    ret
  end
  
    def log(message)
      #logger = ActionController::Base.logger
      #logger.info(message)
      @logger ||= File.open("/tmp/foobar.log", "w")
      puts message
      @logger.puts message
      @logger.flush
    end  
end