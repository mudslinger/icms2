#coding:utf-8

module ApplicationHelper
  def ln2br(str)
    unless str.blank?
      str = ERB::Util.html_escape(str).gsub(/\r\n/, "\n")
      str.gsub("\n", "<br/>")
    end
  end
  
  #
  #atumari暫定
  #記事の作成者か管理者権限の場合
  def has_kousin_kengen?(entry)
    entry.user_has_kousin_kengen?(current_user)
  end
  #
  #atumari暫定
  def has_privilege?
    current_user && current_user.has_privilege?
  end
  
  #
  #ユーザー固有のスタイルシート
  #
  def custom_stylesheet_link_tag
    custom_stylesheet = session[:custom_stylesheet]
    unless custom_stylesheet.blank?
      #stylesheet_link_tag "custom/noheader", :cache => false
      stylesheet_link_tag custom_stylesheet , :cache => false
    end
  end
  
  
  def calendar(name, date_field_name, options = {})
    #name = "job"
    #date_field_name = "kikan_start"
    
    #contents = { Date.today => "http://www.izumo.ne.jp/foo/bar" }
    #contents = Hash.new{|hash,key| hash[key] = []}
    contents = {}
    
    str = ""
    str << %!<table  width="220">!
    today = Date.today
     
    date = if params[:year] && params[:month]
      Date.new(params[:year].to_i,params[:month].to_i, 1)
    else
      Date.today
    end
    
    #まだセットしていなければ取得する。
    @entries_for_monthly_archives ||= entries_for_monthly_archives(name, date_field_name, date.year, date.month) 
    @entries_for_monthly_archives.each{|entry|
      key = entry._cf(date_field_name).to_date #Dateでないといけない
      #重複する場合は?
      contents[key] ||= entry 
    }
    
    
    
    from, to = cal_range(date)
    
    beginning_of_week = from.wday
    end_of_week = to.wday

    str << "<caption>"
    str << link_to_if(entries_for_monthly_archives(name, date_field_name, date.year, date.month, :comparison => :less_than).exists? , "<<", contents_monthly_archives_path(:name =>name, 
      :date_field_name=> date_field_name, :year =>date.prev_month.year, :month =>date.prev_month.month ))
    str << link_to( date.strftime("%Y年%-m月"), "#{root_path}#{name}/calendar?year=#{date.year}&month=#{date.month}")
    str << link_to_if(entries_for_monthly_archives(name, date_field_name, date.year, date.month, :comparison => :greater_than).exists?, ">>", contents_monthly_archives_path(:name =>name, 
      :date_field_name=> date_field_name, :year =>date.next_month.year, :month =>date.next_month.month ))
    str << "</caption>"
    #str << "<tbody>"
    str << "<tr>"
    
    #warr = ["日", "月", "火", "水", "木", "金", "土"]
    #warr.each do |w|
    #  str << "<th>#{w}</th>"
    # end
    str << %!<th class="holiday" scope="col">日</th><th scope="col">月</th><th scope="col">火</th><th scope="col">水</th><th scope="col">木</th><th scope="col">金</th><th scope="col">土</th>!
    str << "</tr>"
    
    cur = from
    while cur <= to

      if cur.wday == beginning_of_week
        str << "<tr>"
      end
      
      css_class = if cur == today
        "today"
      end
    
      day_text = cur.month == date.month ? cur.day : ""
      if contents.has_key? cur
        entry = contents[cur]
        lnk = contents_monthly_archives_path(:name => name, 
        :date_field_name => date_field_name,
        :month => date.month,
        :year => date.year, :anchor => entry.id)
        str << %!<td align="center" class="#{css_class}">#{link_to(day_text, lnk)}</td>!
      else
        str << %!<td align="center">#{day_text}</td>!  
      end
      
      
      if cur.wday == end_of_week
        str << "</tr>\n"
      end
      cur = cur.next_day
    end
    
    #str << "</tbody>"
    str << "</table>"
    str.html_safe
  end
  
  private
  
  #カレンダーを描画する際に使用する開始日と終了日を返す
  #param1 n月分
  #return1 最初のセルに入る日付
  #return2 最後のセルに入る日付
  def cal_range(date)
    start_of_week= 0
    end_of_week = (start_of_week  + 6) % 7
    
    #cur = Date.today.beginning_of_month
    cur = date
    if date.day != 1
      #cur = month_offset.months.since cur
      cur = cur.beginning_of_month
    end
    wday = cur.wday
    offset = ( wday  + (7  - start_of_week ) % 7 ) % 7

    from = (offset).days.ago(cur)
    eom = cur.end_of_month
    end_offset = ( end_of_week - eom.wday + 7 ) % 7
    to = end_offset.days.since(eom)
    [ from , to ]
  end
  
  def javascript_include_tag_default
    javascript_include_tag "jquery-1.5.min", :rails, :application, :cache => false
  end

  
  
end
