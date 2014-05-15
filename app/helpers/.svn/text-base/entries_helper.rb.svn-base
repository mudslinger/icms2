#coding:utf-8
module EntriesHelper
  
  #ボタン等の有効／無効
  def enabled_flags
    unless @enabled_flags
      
      @enabled_flags = {}
      @enabled_flags[:sakujo] = false
      @enabled_flags[:fukki] = false
      @enabled_flags[:gomibako] = false
      @enabled_flags[:sitagaki] = false
      @enabled_flags[:kettei] = false
      @enabled_flags[:syounin]     = false
      @enabled_flags[:syounin_torikesi]     = false
      
      has_syounin_kengen = @entry.user_has_syounin_kengen?(current_user)
      
      case @entry.status
        when "trash"
          @enabled_flags[:sakujo] = true
          @enabled_flags[:fukki] = true
        when "draft"
        @enabled_flags[:sitagaki] = true
        @enabled_flags[:kettei] = true
        @enabled_flags[:gomibako] = true
        when "pending"
        @enabled_flags[:sitagaki] = true
        @enabled_flags[:kettei] = true
        @enabled_flags[:gomibako] = true
        if has_syounin_kengen
          @enabled_flags[:syounin]     = true
        end
        when "publish"
        if has_syounin_kengen
          @enabled_flags[:syounin_torikesi]     = true
          @enabled_flags[:kettei]     = true
        end
      else
        raise "不明なステータス:#{@entry.status}"  
      end
    end
  

    @enabled_flags
  end
  
#  def default_status_filer_selected
#    local_session[:default_status_filter]
#  end
  
  #
  #
  #
  def local_session
    session['entries_controller'] ||= {}
  end
  
  STATUS_LABEL = { "trash" => "ゴミ箱",
      "draft" => "下書き",
      "pending" => "承認待ち",
      "publish" => "公開可" }.freeze
  #
  #
  #    
  def status_label(status)
    STATUS_LABEL[status]
  end
  
  #
  #カテゴリ選択プルダウン
  #
  def options_for_select_form_id(selected_value = nil)
    op = []
    op << ["すべて", ""]
    current_user.browsable_forms.order("id").each do |frm|
      op << [ frm.title, frm.id  ]
    end
    options_for_select(op, selected_value)
  end
  
  #
  #選択中のカテゴリ名
  #
  def selected_category_name(selected_value = nil)
    return "全カテゴリ" if selected_value.blank?
    frm = Form.where("id=?", selected_value).first
    return "" unless frm #カテゴリが削除されたときのため
    return frm.title
  end
  
  #
  #印刷機能有無判定
  #
  def print_function_enabled
    @searchform["form_id"] == "11"
  end
  
  #
  #データ取り込み可否
  #
  def import_function_enabled
    not @searchform["form_id"].blank?
  end

  #
  #データ取り込み用リンク
  #
  def data_torikomi_path()
    frm = Form.where("id=?", @searchform['form_id']).first
    return "/" if frm.blank?
    entries_import_path(:name => frm.template_name )
  end
  
  #
  #カスタムフィールド フォーム入力部品
  #  
  def cf_tag(field_name, entry, options = {})
    #"a<a>".html_safe
    
    field = entry.form.fields.where("name = ?", field_name).first
    result = ""
    
    case field.ftype
      when "text"
      #result += text_field_tag("f[#{field.name}]" , entry._cf(field.name), {:class => "text_field"}.merge(options) ) 
      result += cf_text_field_tag(field_name, entry, {:class => "text_field"}.merge(options))
      
      when "textarea"
      #result += text_area_tag("f[#{field.name}]" , entry._cf(field.name) , {:cols => 60 }.merge(options))
      result += cf_text_area_tag(field_name, entry,  {:cols => 60 }.merge(options))
      
      when "richtext"  
      #result += text_area_tag("f[#{field.name}]" , entry._cf(field.name) , {:cols => 60, :class => "wysiwyg" }.merge(options))
      result += cf_text_area_tag(field_name, entry, {:cols => 60, :class => "wysiwyg" }.merge(options))
      
      when "checkbox"  
      checked_values = entry._cf(field.name).to_s.split(/[\r\n]+/)
      
      
      field.options.split(/[\r\n]+/).each_with_index do |option, i| 
        
        result += check_box_tag("f[#{field.name}][#{i}]", option, checked_values.include?(option) , options) 
        result += label_tag "f[#{field.name}][#{i}]", option 
      end
      
      when "url"
      #result += text_field_tag("f[#{field.name}]" , entry._cf(field.name), {:class => "text_field"}.merge(options))
      result += cf_text_field_tag(field_name, entry, {:class => "text_field"}.merge(options))
      
      when "geocode"
      #result += text_field_tag("f[#{field.name}]" , entry._cf(field.name), {:class => "text_field"}.merge(options))
      result += cf_text_field_tag(field_name, entry, {:class => "text_field"}.merge(options))
      
      result += link_to "地図参照...", "#", {:onclick => "geoCodePick('#{admin_geocode_picker_path}', 'f_#{field_name}');"}
      
      when "entry"
      ext_entry_id = entry._cf(field_name)
      entry_title = if ext_entry_id.present?
        ext_entry = Entry.where(:id => ext_entry_id).first
        if ext_entry.present?
          ext_entry.title
        end
      end
      
      
      result += cf_hidden_field_tag(field_name, entry, options)
      result += content_tag(:div, entry_title, {:id => "f_#{field_name}_title"}.merge(options))
      result += link_to "選択する", "#f_#{field_name}_title", 
      {
        :onclick => "entryPick('#{entry_picker_path}', 'f_#{field_name}');",
        
      }

      if ext_entry_id.present?
        result += "&nbsp;&nbsp;&nbsp;"
        result += link_to "削除", "#f_#{field_name}_title",
          {
            :onclick => "entryPickDelete('f_#{field_name}');",
            
          }
      end
      
      
      
      when "datetime"
      @f = entry.cf
      #=text_field_tag("f[#{field.name}]" , entry._cf(field.name), :class => "text_field") 
      #依頼により1900年から選択可能にする
      result +=  datetime_select "f", field.name, {:date_separator => '/', :start_year => 1900}.merge(options) 
      result += render :file => "_share/datepicker_js", :locals => {:name => "f", :property => field.name } 
      
      when "date"     
      @f = entry.cf
      result +=  date_select "f", field.name, {:date_separator => '/', :start_year => 1900}.merge(options) 
      result += render :file => "_share/datepicker_js", :locals => {:name => "f", :property => field.name } 
      
      when "select"  
      result += select_tag(
        "f[#{field.name}]",
      options_for_select(field.options_for_select, entry._cf(field.name)), options) 
      
      when "radio" #ラジオボタン 
      field.options.split(/[\r\n]+/).each_with_index do |option,i|
        result += radio_button_tag "f[#{field.name}]", option, (option == entry._cf(field.name)), {:id => "f_#{field.name}_#{i}"}.merge(options) 
        result += label_tag( "f_#{field.name}_#{i}", option ) 
        result += "<br/>"
      end
      
      when "file"
      
      result += file_field_tag "f[#{field.name}][file_value]", options
      #↓バリデーションに失敗してフォームを再描画したとき、ファイルが消えないようにする 
      result += hidden_field_tag "f[#{field.name}][file_value_cache]", entry._cf_meta(field.name).file_value_cache 
      unless entry._cf(field.name).blank? 
        result +=  link_to("ファイル",image_path(entry._cf(field.name).url), :target => "_blank")
        result +=  " "
        result +=  check_box_tag "f[#{field.name}][remove_file_value]" 
        result +=  "削除"
      end
      
      
      when "image" #画像 
      #=file_field_tag "f[#{field.name}]"
      result += file_field_tag "f[#{field.name}][file_value]", options
      #↓バリデーションに失敗してフォームを再描画したとき、ファイルが消えないようにする 
      result += hidden_field_tag "f[#{field.name}][file_value_cache]", entry._cf_meta(field.name).file_value_cache 
      unless entry._cf(field.name).thumb.blank? 
        result +=  link_to(image_path(entry._cf(field.name).url), :target => "_blank") do 
          image_tag entry._cf(field.name).thumb.url 
        end
        result +=  " "
        result += check_box_tag "f[#{field.name}][remove_file_value]" 
        result += "削除"
      end
      
      
      
      
    end #end when 
    
    result.html_safe
  end
  
  #
  #カスタムフィールド(テキストフィールド)
  #
  def cf_text_field_tag(field_name, entry, options = {})
    field = entry.form.fields.where("name = ?", field_name).first
    text_field_tag("f[#{field.name}]" , entry._cf(field.name), options ) 
  end
  
  #
  #カスタムフィールド(テキストエリア)
  #
  def cf_text_area_tag(field_name, entry, options = {})
    field = entry.form.fields.where("name = ?", field_name).first
    text_area_tag("f[#{field.name}]" , entry._cf(field.name) , options)     
  end
  
  #
  #カスタムフィールド(隠しフィールド)
  #
  def cf_hidden_field_tag(field_name, entry, options = {})
    field = entry.form.fields.where("name = ?", field_name).first
    hidden_field_tag("f[#{field.name}]" , entry._cf(field.name), options ) 
  end
  
  def entry_picker_path
    @entry_picker_path ||= File.join(root_path, "entry_picker")
  end
  
end
