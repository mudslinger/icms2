#coding:utf-8
class EntryMetaDelegator
  def initialize(e)
    @entry = e
    @custom_values = {}
    @entry_metas = {}
    @fields = {}
  end
  
  #  def method_missing(method_id, *arguments, &block)
  #    
  #    ret = nil
  #    obj = nil
  #    method_name = method_id.to_s
  #    field_name = method_name 
  #    if method_name[-1] == "="
  #      field_name = method_name.chop
  #    end
  #    
  #    unless @custom_values
  #      @custom_values = {}
  #      
  #      @entry.entry_metas.each{|em|
  #        
  #        @custom_values[em.field.name] =em
  #      }
  #    end
  #    
  #    
  #    if method_name[-1] == "="
  #      
  #    else
  #      obj = @custom_values[field_name]
  #    end
  #    if obj
  #      ret = obj.string_value
  #    end
  #    
  #    ret
  #  end
    def logger
      ActionController::Base.logger
    end
  
  
  def method_missing(method_id, *arguments, &block)
    
    
    method_name = method_id.to_s
    field_name = method_name 
    if method_name[-1] == "=" #アサイン
      field_name = method_name.chop
      return set_field_value(field_name,arguments.first)
    else
   
      unless @custom_values.has_key? field_name
       
        @custom_values[field_name] = load_field_value(field_name)
      end
      return @custom_values[field_name]
    end
  end
  
  private
  
  #
  #ロード
  #
  def load_field_value(field_name)
    
    ret = nil
    field, meta_value = _load_field_meta(field_name)
    unless meta_value
      return nil
    end
    
    #field = @entry.form.fields.where("name=?", field_name).first
    #case meta_value.field.ftype
    case field.ftype
      when "image", "file"
      ret = meta_value.file_value
      when "datetime", "date"
      ret = meta_value.date_value
      when "textarea","richtext"
      
      ret = meta_value.text_value
      
    else
      
      ret = meta_value.string_value
    end
    ret
  end
  
  #
  #ロードメタ
  #
  public
  def load_field_meta(field_name)
    
#    field = @entry.form.fields.where("name=?", field_name).first
#    unless field
#      #フィールド名間違いか、削除された
#      return nil
#    end
#    meta_value = nil
#    unless @entry_metas.has_key? field_name
#      meta_value = @entry.entry_metas.where("field_id=?", field.id).first
#      unless meta_value
#        meta_value = EntryMeta.new
#        meta_value.field_id = field.id
#        meta_value.entry_id = @entry.id
#        @entry.entry_metas << meta_value
#      end
#      @entry_metas[field_name] = meta_value
#    end
#    meta_value = @entry_metas[field_name]
#
#    meta_value
    field, meta_value = _load_field_meta(field_name)
    return meta_value
  end
  
  
  #
  #ロードメタ(private)
  #
  private
  def _load_field_meta(field_name)
    field = @fields[field_name]
    field ||= @entry.form.fields.where("name=?", field_name).first
    unless field
      #フィールド名間違いか、削除された
      return [nil,nil]
    end
    meta_value = nil
    unless @entry_metas.has_key? field_name
    
      meta_value = @entry.entry_metas.where("field_id=?", field.id).first
      unless meta_value
#        meta_value = EntryMeta.new
#        meta_value.field_id = field.id
#        meta_value.entry_id = @entry.id
        #TODO デフォルト値のセット
        meta_value =  set_field_value(field_name, field.default)

        @entry.entry_metas << meta_value
      end
      @entry_metas[field_name] = meta_value
    end
    meta_value = @entry_metas[field_name]

    return [field , meta_value]
  end  
  #
  #セット
  #
  private
  def set_field_value(field_name, value)
    field = @entry.form.fields.where("name=?", field_name).first
    meta_value = @entry.entry_metas.where("field_id=?", field.id).first
    hash_value = {}
    
    case field.ftype
      when "image", "file"
      hash_value = value
     
     when "datetime", "date"
     hash_value = value
      
      when "textarea","richtext"
      
      hash_value["text_value"] = value
      
      when "checkbox"
      if Hash === value
        value = value.values.join("\n")
      end
      hash_value["string_value"] = value
    else
      hash_value["string_value"] = value
    end
    
    #↓文字列が入っているとエラーになるため。
    hash_value = {} if hash_value.blank? 
    
    unless meta_value
      meta_value = EntryMeta.new(hash_value)
      meta_value.entry_id = @entry.id
      meta_value.field_id = field.id
      #meta_value.save!
    else
      #meta_value.update_attributes!(hash_value)
      #↑は使わない.後でまとめてsave!するため
#      hash_value.each{|k,v|
#     
#        meta_value.__send__("#{k}=", v)
#      } 
      meta_value.attributes = hash_value
      
    end
    @entry_metas[field_name] = meta_value
  end
  
  public
  def save_cached!
    @entry_metas.values.each{|me|
      #insert/updateいずれも一括でセーブする
      #エラーが起こったとき検知できるようにsaveではなくsave!をつかう
      me.save!
    }
    
    
  end
  
  def preload_custom_fields
logger.debug "プリロード"

    @entry.entry_metas.all(:include => "field").each{|meta_value|
      field = meta_value.field
      @fields[field.name] = field
      @entry_metas[field.name] = meta_value
    }
    
  end
  
  
  
end

class Entry < ActiveRecord::Base
  belongs_to :created_by,  :class_name => "User"
  belongs_to :updated_by,  :class_name => "User"  
  belongs_to :form
  #紐づいたentry_metaと添付ファイルを自動的に削除
  has_many :entry_metas, :dependent => :destroy
  
  paginates_per 30

  before_save :custom_validation
  
  #カスタムフィールドを含め、save完了後に呼ばれるハンドラを格納する
  attr_accessor :after_all_save_handler
  
  def initialize(*args)
    super
    self.status = "draft"
  end
  
  def preload_custom_fields
    @em_delegator = EntryMetaDelegator.new(self)
    @em_delegator.preload_custom_fields
  end
  
  #
  #指定されたユーザーがこの記事の承認権限を持つかどうか
  #
  def user_has_syounin_kengen?(user)
    user.has_syounin_kengen?
  end
  
  
  
  #指定されたユーザーがこの記事の更新権限を持つかどうか
  #atumari暫定
  #
  def user_has_kousin_kengen?(user)
    user.can_write_others_file? || (self.created_by && self.created_by.id == user.id)
  end
  
  def custom_validation
    unless ["trash", "draft", "pending", "publish"].include?(self.status)
      errors.add_to_base "status not in one of trash, draft, pending, publish"
    end
    
  end
  
  #作成者名
  def created_by_name
    created_by ? created_by.name : ""
  end
  
  #更新者名
  def updated_by_name
    updated_by ? updated_by.name : ""
  end
  
  
  #  def f
  #    unless @custom_fields
  #      @custom_fields = {}
  #      self.entry_metas.each{|em|
  #        @custom_fields[em.field.name] =em.string_value
  #        
  #      }
  #    end
  #    @custom_fields
  #  end
  
  def cf
    unless @em_delegator
      @em_delegator = EntryMetaDelegator.new(self)
    end
    @em_delegator
  end
  
  #
  #フィールド名で取得
  #
  def _cf(fname)
    @em_delegator ||= EntryMetaDelegator.new(self)
    @em_delegator.__send__(fname)
  end
  
  def _cf_meta(fname)
    @em_delegator ||= EntryMetaDelegator.new(self)
    @em_delegator.load_field_meta fname
  end
  
  #  def save_entry_metas(params)
  #    
  #    _f = params[:f]
  #    hs = {}
  #    self.entry_metas.each{|me|
  #      hs[me.field.name] = me
  #      
  #    }    
  #    
  #    self.form.fields.each{|field|
  #      em = hs[field.name]
  #      unless em
  #        em = EntryMeta.new
  #        em.entry_id = self.id
  #      end
  #      
  #      em.field_id = field.id
  #      
  #      
  #      
  #      case em.field.ftype
  #        when "checkbox"
  #        if _f[field.name]
  #          em.string_value = _f[field.name].values.join("\n")
  #        end
  #        
  #        when "image", "item"
  #        #logger.debug "ファイルみつかった#{field.name}"
  #        obj = _f[field.name]
  #        if obj
  #          File.rename(obj.tempfile, File.join(Rails.root, "public", "images",  obj.original_filename))
  #          value = obj.original_filename
  #          logger.debug "#{obj.class}"
  #          logger.debug obj.inspect
  #        end
  #      else
  #        em.string_value = _f[field.name]
  #        
  #      end
  #      
  #      if field.required == 1
  #        if em.string_value.blank?
  #          errors.add_to_base("#{field.label}は必須項目です")  
  #        end
  #      end
  #      em.save!
  #    }
  #    self.errors.size <= 0
  #  end
  
  
  def save_entry_metas(params)
    
    _f = params[:f]
    @em_delegator ||= EntryMetaDelegator.new(self)
    
    
    self.form.fields.each{|field|
      
      value = case field.ftype
        when "datetime", "date"
        convert_params_for_datetime(_f, field.name)
      else
        _f[field.name]
      end
      
      @em_delegator.__send__("#{field.name}=", value)
      
      if field.required?
        if @em_delegator.__send__(field.name).blank?
          errors.add(:base, "#{field.label}は必須項目です")  
        end
      end
      
    }
    if self.errors.size <= 0
      logger.debug "save_cached!"
      @em_delegator.save_cached!
    end
    
    self.errors.size <= 0
  end
  
  private
  def self.sql_valid_article
    #ステータスが公開で、かつ期限が公開期間内にある
    "status='publish' AND 
      ( 
        (? BETWEEN date_begin AND date_end) OR 
        (date_begin IS NULL AND date_end >= ?) OR 
        (date_begin <= ? AND date_end IS NULL ) OR
        (date_begin IS NULL AND date_end IS NULL) 
       ) "    
  end
  
  private
  def notify_syounin()
    entry = self
    #記事の承認権限を持つユーザー列挙
    entry.form.permitted_users.where("user_level=2").each{|user|
      unless user.emailaddress.blank?
        logger.debug "承認依頼メール to: #{user.name}"   
        UserMailer.syounin_irai(user, entry).deliver
      end
    }
    
  end
  
  #
  #カスタムフィールド"notify_on_post"がチェックされていたら全員にメール送る
  #
  def notify_post()
    entry = self
    if entry.cf.notify_on_post.blank?
      logger.debug "チェックされていないので通知しない"
      return
    else
      logger.debug "通知する"
    end
    
    User.all.each{|user|
      unless user.emailaddress.blank?
        logger.debug "投稿メール to: #{user.name}"   
        UserMailer.notify_on_post(user, entry.created_by, entry).deliver
      end
    }
    
  end  
  
  public
  def after_all_save
    unless after_all_save_handler.blank?
      self.__send__ after_all_save_handler
    end
  end
  
  
  #
  #最初の画像フィールドの値
  #
  def first_image_field_value
    _f_image_field = self.form.fields.where(:ftype => "image").first
    unless _f_image_field.blank?
      self._cf _f_image_field.name
    end
  end
  
  public
  #ステータスが公開で、かつ期限が公開期間内にある
  def self.where_valid_article
    now = Time.now
    self.where( Entry.sql_valid_article , now, now, now)
  end
  
  
  def self.sql_date_event_article
    #指定した時間範囲において、公開開始になるか、公開終了になるものを列挙
    "status='publish' AND 
      ( 
        (date_begin BETWEEN ? AND ?) OR 
        (date_end   BETWEEN ? AND ?) 
       ) "    
  end  
  
  #
  #指定した時間範囲において、公開開始になるか、公開終了になるもの
  #
  def self.date_event_article(from, to)
    self.where(self.sql_date_event_article, from , to, from, to)
  end
  
  #
  #ステータス更新
  #
  def self.update_status(entry, action, user)
    logger.info "ステータス更新試行 status:#{entry.status}, action:#{action}"
    next_status = nil
    errors = []
    #errors << "エラーテスト"
    case entry.status
      when "trash"
      
      case action
        when "fukki" , "sakujo"
        next_status = "draft"
      else
        errors << "不明なアクション#{entry.status},#{action}"        
      end
      
      when "draft"
      
      case action
        when "sitagaki"
        next_status = "draft"
        when "kettei"
        #承認依頼メール
        #notify_syounin(entry)
        entry.after_all_save_handler = :notify_syounin
        next_status = "pending"
        when "gomibako"
        next_status = "trash"
      else
        errors << "不明なアクション#{entry.status},#{action}"
      end
      
      when "pending"
      
      case action
        when "sitagaki"
        next_status = "draft"
        when "kettei"
        next_status = "pending"
        when "gomibako"
        next_status = "trash"
        when "syounin"
        if entry.user_has_syounin_kengen?(user)
          #entry.after_all_save_handler = :notify_post
          next_status = "publish"
        else
          errors << "承認権限がありません"
        end
      else
        errors << "不明なアクション#{entry.status},#{action}"
      end
      
      when "publish"
      case action
        when "syounin_torikesi"
        if entry.user_has_syounin_kengen?(user)
          next_status = "pending"
        else
          errors << "承認権限がありません"
        end
        when "kettei"
        if entry.user_has_syounin_kengen?(user)
          next_status = "publish"
        else
          errors << "承認権限がありません"
        end
        
      else
        errors << "不明なアクション#{entry.status},#{action}"
      end
      
      
    else
      errors << "不明なステータス#{entry.status}"
    end
    
    if errors.empty?
      entry.status = next_status
      logger.info "ステータス更新:#{entry.status}"
    end
    return errors
  end  
  

  
  #
  #カスタムフィールドフィルター
  #  #バグ：後でentries.per, entries.page等を呼び出すと事前にセットしたorderがリセットされる
  def self.cf_filter(entries, name, options)
  #options = { :where => "{gaiyou} = 'とげ' OR {display_date} LIKE '%er%'", :order => "{app_serial}, {display_date} DESC"  }

    field_alias_map = {}
    [options[:where], options[:order]].each{|str|
      next unless str
      str.scan(/\{([^}]+)\}/){|m|
        mt = $~
        fname = mt[1]
        field_alias_map[fname] = nil
      }
    
    }
    
    
    form = Form.where("template_name = ?", name).first
    fieldnames = field_alias_map.keys
    fieldnames.each_with_index{|fname,idx|
      field = form.fields.where("name=?", fname).first
      table_alias = "entry_metas_#{fname}"
      entries = entries.joins("LEFT OUTER JOIN entry_metas AS #{table_alias} ON #{table_alias}.entry_id=entries.id AND #{table_alias}.field_id=#{field.id}")
      meta_field = field.meta_field_name
      
      field_alias = "#{table_alias}.#{meta_field}"
      
      field_alias_map[fname] = field_alias
    }

    [:where, :order].each{|key|
     next unless options[key]
      sql = options[key].gsub(/\{([^}]+)\}/){
        mt = $~
        fname = mt[1]
        field_alias_map[fname]
      }
      options[key] = sql
#logger.debug "書き換え:#{sql}"      
    }
    
    if options[:where]
      entries = entries.where(options[:where])
    end
    
    if options[:order]
      #exceptとするとpaginateとの相性が悪い
      #entries = entries.except(:order).order(options[:order])
      #entries = entries.order(options[:order])
      entries = entries.order(options[:order])
      #order by フィールドの順序を変える(先頭に持ってくる)
      #Arelの仕様が変わると動かなくなるので本当はこのやり方はよくない
      entries.orders.unshift(entries.orders.pop)
    end
    #後からentries.page(params[:cat_page])とすると、なぜか事前にセットしたper_page, orderがリセットされる?
    #次のようにして再設定entries.except(:order).order("id").page(params[:cat_page]).per(10)
    
    entries
  end
  
  
  class << self
  def csvdata(entries, form)
    buf = ""
    headers = ["id", "タイトル", "内容"]
    form.fields.each do |field|
      headers << field.label
    end
    full_sanitizer ||= HTML::FullSanitizer.new
    
    headers += ["作成日", "更新日", "作成者"] #, "更新者"] 
    
    buf << csvconv(headers) << "\r\n" 
    entries.each do |entry|
      entry.preload_custom_fields
      arr = []
      arr << entry.id
      arr << entry.title
      arr << full_sanitizer.sanitize( entry.content)
      entry.form.fields.each{|field|
        fvalue = entry._cf(field.name)
        fvalue = case field.ftype
          when "datetime"
            fvalue.present? ? fvalue.strftime("%Y/%m/%d %H:%M:%S") : ""
          when "date"
            fvalue.present? ? fvalue.strftime("%Y/%m/%d") : ""
          when "richtext"
            #strip_tags
            
            full_sanitizer.sanitize fvalue
          else
            fvalue
        end
    
          
        arr << fvalue
      }
      arr << entry.created_at.strftime("%Y/%m/%d %H:%M:%S")
      arr << entry.updated_at.strftime("%Y/%m/%d %H:%M:%S")
      arr << entry.created_by_name
      #arr << entry.updated_by.name
      
      buf << csvconv(arr) << "\r\n"
    end
    buf
  end
  
  def csvconv(arr)
    arr.map{|b|
      str = b
      str = "" if b.blank?
      str = str.to_s.gsub('"', '""') 
      %!"#{str.encode('windows-31j', :undef => :replace)}"!  
    }.join(",")
  end     
  end
  
  private 
  #
  #日付フィールド用
  #
  def convert_params_for_datetime(hs, name)
    ret = {}
    hs.each{|key,val|
      if mt = /^(#{name})\((\d+)i\)$/.match(key)
        index = mt[2]
        new_key = "date_value(#{index}i)"
        ret[new_key] = val
      end
    
    }
    ret
  end  
  
end
