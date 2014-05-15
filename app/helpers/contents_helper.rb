#coding:utf-8
require 'rss'
module ContentsHelper
  
  include CustomHelper #サイトに固有のヘルパ
  
  def each_headline(name, per_page = 5, options = {})
    per_page = per_page == :all ? 999 : per_page
    #logger.debug("each_headline(#{name})が呼ばれた")
    
    elements = headline(name,per_page, options) 
    if block_given?
    #cache "headline_#{name}" do
     # logger.debug("cacheブロックの中")
      elements.each do |entry|
        
        yield entry
      end
    #end
    else
       return elements
    end
  end
  
  def each_headline2(name, per_page = 5, options = {})
    per_page = per_page == :all ? 999 : per_page
    #logger.debug("each_headline(#{name})が呼ばれた")
    elements = headline2(name,per_page, options) 
    if block_given?
    #cache "headline_#{name}" do
     # logger.debug("cacheブロックの中")
      elements.each do |entry|
	yield entry
      end
    #end
    else
       return elements
    end
  end

 #
 #カテゴリの件数を表示
 #
 def contents_count(name, per_page = 5, options = {})
   headline(name,per_page, options).total_count
 end
 
 #カスタムフィールドで並び替え
=begin
sql="
select 
entries.*,
entry_metas.string_value 
from entries, forms, fields, entry_metas 
where 
forms.template_name='akiya_bank' and forms.id=entries.form_id and 
forms.id=fields.form_id and fields.name='no' and 
entries.id=entry_metas.entry_id and 
entry_metas.field_id=fields.id 
order by entry_metas.string_value
"
Entry.find_by_sql sql  
=end
  
  
  def contents_detail_path_for(entry)
    contents_detail_path(:name => entry.form.template_name, :id => entry.id)
  end
  
  #特定のフィールドでソートする。
  #数値とみなす
  def nsort_by(entries, fname)
    entries.sort_by{|ele| 
      value = ele._cf(fname)
      value.tr('０-９', '0-9').to_i
    }
  end


  def ln2br(str)
    unless str.blank?
      str = ERB::Util.html_escape(str).gsub(/\r\n/, "\n")
      str.gsub("\n", "<br/>")
    end
  end
  
  #
  #
  #カスタムフィールドの値によってグループ化
  #
  def group_by(entries, fieldname )
    
    hs = Hash.new{|hash,key| hash[key] = [] }
    entries.each{|entry|
      value = entry._cf(fieldname)
      hs[value] << entry
    }
    hs
  end
  
  def group_by2(entries, fieldname )
    
    hs = Hash.new{|hash,key| hash[key] = [] }
    entries.each{|entry|
      value = entry[fieldname]
      hs[value] << entry
    }
    hs
  end
  
  #
  #RSS
  #
  def each_headline_rss(rss_source, count)
    cache "headline_rss" do
      rss = nil
      begin
        rss = RSS::Parser.parse(rss_source)
      rescue RSS::InvalidRSSError
        rss = RSS::Parser.parse(rss_source, false)
      end
      
      #rss.items.sort_by{ |i| i.date  }.reverse[0 .. 6].each do |item|
      rss.items[0 .. count - 1].each do |item|
        #puts item.date
        #puts "#{item.title} : #{item.date.strftime('%Y-%m-%d')}"
        yield item
      end
      
    end
  end
  
  #
  #公開からn日間、newという画像を表示する
  #
  def new_image_tag(entry, days, image_path = "new.gif")
    if entry
      date_to_compare = entry.date_begin
      date_to_compare ||= entry.created_at
      
      if days.days.since(date_to_compare) >= Time.now
        image_tag image_path
      end
    end
  end
  
  #
  #記事IDを指定して取得する
  #
  def entry_by_id(id)
    Entry.where_valid_article.where(:id => id).first    
  end
  
  #緯度経度から近隣のエントリーを検索して返す。
  # org: 起点となるEntry
  # entries: 検索対象となるリスト
  # max:  結果を上位max位返す
  # options:  :attr_name 緯度経度が格納されているフィールドの名前。省略時のデフォルトはlocation
  #           :within  指定したキロメートル以内で検索する。省略時は距離制限なし。
  def neighbor_entries(org, entries, max, options = { :attr_name => "location"})
    options = { :attr_name => "location"}.merge(options)
    attr_name = options[:attr_name]
    within = options[:within]
    org_lat, org_lng = org._cf(attr_name ).to_s.split(",")
    return [] if org_lat.blank? || org_lng.blank? || org_lat == "0.0" || org_lng == "0.0"|| org_lat == "0" || org_lng == "0"
    org_lat, org_lng = org_lat.to_f, org_lng.to_f


    arr2 = [] 
    entries.each{|ele|
      next if ele.id == org.id
       lat, lng = ele._cf(attr_name ).to_s.split(",")

       if lat.blank? || lng.blank? || lat == "0.0" || lng == "0.0"|| lat == "0" || lng == "0"
          distance = Float::INFINITY
       else
            lat, lng = lat.to_f, lng.to_f
          distance =  distance_between([lat,lng], [org_lat, org_lng])
          #distance2 =  simple_distance_between([lat,lng], [org_lat, org_lng])
       end

       if within && within < distance
         #距離の範囲外
         next
       end
       arr2 << [ele, distance]
    }
    arr3 = []
    
    arr2.sort_by{|e| e[1] }.each_with_index{|ele,i|
      entry = ele[0]
      arr3 << entry

      if (i + 1) >= max
        #puts
        break
      end
    }
    arr3
  end
  private
  #require 'geocoder'
  def distance_between(point1, point2)
    Geocoder::Calculations.distance_between(point1, point2, {:units => :km})
  end
#  def simple_distance_between(point1, point2)
#     Math.sqrt((point1[0] - point2[0]) ** 2  + (point1[1] - point2[1]) ** 2  )
#  end
  
  def file_exists?(img_path)
    File.exists?(File.join(Rails.root, 'public', img_path ))
  end
  
end
