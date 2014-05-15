#coding:utf-8
#表のページ・裏のページコントローラ共通で使用する機能を実装
#
module ContentsRenderer
  
  #
  #レンダリング(トップページ)
  #
  def render_top
    
    template_dir = "contents"
    template_file =  File.join(template_dir, "top")
    
    
    
    begin
      #render :template => template_file, :layout => calc_layout_file_name(template_name) # :layout =>  "page.html.erb"
      render :template => template_file, :layout => nil
    rescue ActionView::MissingTemplate => evar
      template_dir = File.join("contents", "_default")
      template_file =  File.join(template_dir, "show")
      render :template => template_file, :layout => nil
    end
  end  
  
  #
  #レンダリング(詳細表示)
  #
  def render_entry
    begin
      template_name  = @entry.form.template_name
      respond_to do |format|
        
        
        template_dir = File.join("contents", template_name)
        template_file =  File.join(template_dir, "show")
        format.html {
          render :template => template_file, :layout => calc_layout_file_name(template_name) # :layout =>  "page.html.erb"
        }
        #部分テンプレートがないときはActionView::Template::Errorが発生
        
      end
      
    rescue ActionView::MissingTemplate => evar
      respond_to do |format|
        template_dir = File.join("contents", "_default")
        template_file =  File.join(template_dir, "show")
        format.html {
          render :template => template_file, :layout => calc_layout_file_name(template_name) # :layout =>  "page.html.erb"
        }
        
      end
      
    end
  end


  
  #
  #レンダリング(インデックス)
  #
  def render_entry_index(template_name)
    #template_name  = @entries.form.template_name
    template_dir = File.join("contents", template_name)
    template_file = if params[:media] == "print"
      File.join(template_dir, "index_print")
    else
      File.join(template_dir, "index")
    end
    
    begin
      respond_to do |format|
        format.html {
          render :template => template_file, :layout => calc_layout_file_name(template_name) # :layout =>  "page.html.erb"
        }
      end
      
    rescue ActionView::MissingTemplate => evar
      template_dir = File.join("contents", "_default")
      template_file =  File.join(template_dir, "index")      
      respond_to do |format|
        format.html {
          render :template => template_file, :layout => calc_layout_file_name(template_name) # :layout =>  "page.html.erb"
        }
      end
    end
    
  end
  
  #
  #アーカイブ
  #
  def render_monthly_archives(template_name)
    template_dir = File.join("contents", template_name)
    template_file = File.join(template_dir, "archives", "monthly")
    render :template => template_file, :layout => calc_layout_file_name(template_name)
  end
  
  #
  #
  #レンダリング(その他)
  #
  def render_static(filename)
    #ディレクトリが指定された場合、index.htmlがあるかどうか試す
    
#    filename_parts = filename.split(".")
#    action_name =""
#    ext_name = ""
#    if filename_parts >= 2
#      ext_name = filename_parts.pop
#      action_name = File.join(*filename_parts)
#    else
#      ext_name = ""
#      action_name
#    end
    
    #/foo.html      => /foo
    #/bar/fo.html   => /bar/fo
    #/foo           => /foo
    #/bar/          => /bar
    #/baz/pii       => /baz/pii
    #/baz/pii.html  => /baz/pii
    #/baz.x/pii.html       => /baz.x/pii
    #/baz.x/foo.y/gg.html  => /baz.x/foo.y/gg
    #/baz.x/foo.y/gg       => /baz.x/foo.y/gg
    #/baz.x/foo.y/         => /baz.x/foo.y
    #/baz.x/foo.y
    #/baz.x/foo
    
    #拡張子があれば取り除く
    action_name, ext_name = split_action_name_and_format(filename)
    
    template_dir = "contents"
    
    template_file =  File.join(template_dir, action_name)

#    view_dir = File.join("#{Rails.root}", "app", "views")
#    if File.directory?(File.join(view_dir, template_file))
#      template_file = File.join(template_file, "index.html")
#    end
#    unless File.exists?(File.join(view_dir, template_file))
#      logger.info("ファイルが見つかりません:render_static(#{dirname})")
#      render_no_article
#      return
#    end
    
    begin
      render :template => template_file, :layout => nil
    rescue ActionView::MissingTemplate => evar
      begin
        template_file =  File.join(template_dir, filename)
        render :template => File.join(template_file, "index"), :layout => nil
      rescue ActionView::MissingTemplate => evar
        logger.info("ファイルが見つかりません: render_static(#{filename})")
        render_no_article
      end
    end
  end
  
  
  #
  #ヘッドライン
  #per_page に 0入れても30件でる
  def headline(name, per_page = 5, options = {})
   
    #page_parameter_name ページ数のパラメータ名:page を変更する。メインのコンテンツのページ数と混同しないようにする
    #Entry.joins(:form).page(params[:headline_page]).per(per_page).order("updated_at DESC").
    #  where("forms.template_name =? ", name).where( Entry.sql_valid_article , now, now, now)  
    #クエリを単純にするためEntry.joins(:form)を使うのをやめ、クエリを２回に分ける
    page_parameter_name = "page_#{name}".to_sym 
    form = Form.where("template_name = ?", name).first
    entries = Entry.where_valid_article.page(params[page_parameter_name]).order("entries.updated_at DESC").
      where("form_id =? ", form.id)
      
    unless per_page.blank?
  
      entries = entries.per(per_page)
    end 
      
      
    unless options.empty?
      entries = cf_filter(entries, name, options)  
    end
    return entries
  end
  
  #
  #カスタムフィールドフィルター
  #
  def cf_filter(entries, name, options)
    return Entry.cf_filter(entries, name, options)
  end  
  
  private
  #
  #
  #
  def calc_layout_file_name(name)
    media = nil
    if params[:media] == "print" 
      media = "_print"
    else
      
    end
    filename = File.join("contents", "#{name}#{media}.html.erb") 
    unless  File.exists?(File.join("#{Rails.root}", "app", "views", "layouts", filename))
      #return  "contents/common#{media}.html.erb"
      return nil
    end
    return filename
  end
  
  #
  #
  #
  def split_action_name_and_format(fname)
    action_name = fname
    ext_name = File.extname(fname)
    if ext_name != ""
       action_name = fname.sub(/#{ext_name}$/, "")
    end
  
    return [action_name, ext_name]
  end

  #
  #月別
  #
  def entries_for_monthly_archives(name, date_field_name, year, month, options = {})
    
    form = Form.where("template_name = ?", name).first
    #サニタイズ
    raise "フィールド名'#{date_field_name}'が存在しません。" unless form.fields.where(:name => date_field_name).exists?
    
    
    
    entries = Entry.where_valid_article.page(params[:page]).order("id DESC").
      where("form_id =? ", form.id)
    
    timestamp = Time.mktime(year,month,1)
    
    case options[:comparison]
    when :greater_than
      timestamp_e = timestamp.end_of_month.strftime("%F %H:%M:%S")
      options[:where] = "{#{date_field_name}} > '#{timestamp_e}'"
    when :less_than
      timestamp_b = timestamp.beginning_of_month.strftime("%F %H:%M:%S")
      options[:where] = "{#{date_field_name}} < '#{timestamp_b}'"
    else #between
      timestamp_b = timestamp.beginning_of_month.strftime("%F %H:%M:%S")
      timestamp_e = timestamp.end_of_month.strftime("%F %H:%M:%S")
      options[:where] = "{#{date_field_name}} BETWEEN '#{timestamp_b}' AND '#{timestamp_e}'"
      options[:order] ||= "{#{date_field_name}} DESC"
    end

    
    unless options.empty?
      entries = cf_filter(entries, name, options)  
    end
    entries
  end
  
end