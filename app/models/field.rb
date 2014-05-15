#coding:utf-8
class Field < ActiveRecord::Base
  has_many :entry_metas, 
    :dependent => :destroy #紐付けされた値も削除  
  
  validates_presence_of :name, :label
  validates_uniqueness_of :name, :scope => [:form_id]
  validates_format_of :name, :with => /\A[a-zA-Z_][a-zA-Z0-9_]*\z/ , :message => ":使用できる文字は半角英数字、アンダーバーです。数字から始まってはいけません。"
  
  after_validation :custom_validation
  #before_upadate :check_sortkey
  
  def required?
    required == 1
  end
  
  def custom_validation
    if errors.empty?
      if Object.new.respond_to? name.to_sym
        errors.add :name, "#{name}は予約されており利用できません。"
      end
      
    end
    

  end

  #フィールドタイプとDB上のフィールド(型)の対応
  def meta_field_name
      meta_field = case self.ftype
        when "image", "file"
        ret = "file_value"
        when "datetime","date"
        ret = "date_value"
        when "textarea","richtext"
        
        ret = "text_value"
        
      else
        
        ret = "string_value"
    end
    return meta_field
  end

  #ラベルと値は
  #値, ラベルのように区切る
  #カンマが無いときは値＝ラベルとみなす
  def options_for_select
    if options2.blank?
      options.split(/[\r\n]+/).map{ |ele|
        arr = ele.to_s.split(",")
        value = arr[0]
        label = arr.size <= 1 ? value : arr[1]
        [label,value] 
        
      }
    else
      table_name, value_field, label_field, order, where = options2.split(',')
      
      table_name.gsub!(/[{}]/, '')
      value_field.gsub!(/[{}]/, '')
      label_field.gsub!(/[{}]/, '')
      
      frm = Form.where("template_name=?", table_name).first
      return [] if frm.blank?
      
      entries = Entry.where("form_id=?", frm.id)
      options = {}
      unless order.blank?
        options[:order] = order
      end
      
      unless where.blank?
        options[:where] = where
      end
      
      unless options.blank?
        entries = Entry.cf_filter(entries, table_name, options )
      end
      
      ret = []
      entries.each {|entry|
        value = entry._cf(value_field)
        label = entry._cf(label_field)
        ret << [label, value]
      }
      
      ret
    end
  end


  
  FIELDTYPE_MAP = {
    "text"=>"テキスト", 
    "textarea"=>"テキスト複数行",
    "richtext"=>"リッチテキスト", 
    "checkbox"=>"チェックボックス", 
    "url"=>"URL", 
    "datetime"=>"日付と時刻",
    "date"=>"日付", 
    "select"=>"ドロップダウン", 
    "radio"=>"ラジオボタン", 
    #"item"=>"アイテム", 
    "image"=>"画像",
    "file" => "ファイル",
    "geocode" => "緯度経度",
    "entry" => "記事参照",
  }.freeze
    
    
  FIELDTYPE_OPTIONS = lambda{
    arr = []
    FIELDTYPE_MAP.each{|k,v|
      arr << [v,k]
    }
    arr
  }.call.freeze  
end
