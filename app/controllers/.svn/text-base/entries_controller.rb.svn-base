#coding:utf-8
class EntriesController < ApplicationController
  include ContentsRenderer
  helper_method :headline, :cf_filter
  skip_before_filter :site_protected
  #cache_sweeper :contents_cache_sweeper

  
  # GET /entries
  # GET /entries.xml
  def index
    #@entries = Entry.all
    srch = search_form
    unless category_permitted?(srch["form_id"])
      flash.now[:error] = "権限がありません"
      render :template => 'global/error' 
      return
    end
    
    #ゴミ箱ボタン
    if params[:button_trash]
      move_to_trash(params[:checked_entries])
    end
    #削除ボタン
    if params[:button_delete]
      destroy_selected_items(params[:checked_entries])
    end
    #承認取り消しボタン
    if params[:button_cancel_syounin]
      syounin_torikesi_selected_items(params[:checked_entries])
    end
    
    @entries = filtered_list(srch)
    
    add_sub_menu(srch["form_id"])
    
    respond_to do |format|
      format.html {render_custom_template( srch["form_id"], "index") } # index.html.erb
      format.xml  { render :xml => @entries }
      format.csv {
      @entries = @entries.except(:limit).except(:offset)
        send_data Entry.csvdata(@entries, Form.find(srch['form_id'])), 
        :type => "application/octet-stream", 
        :disposition => "attachment; filename=data_#{srch['form_id']}.csv"      
      }
    end
  end
  
  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = Entry.find(params[:id])
    @entry.preload_custom_fields
    add_sub_menu(search_form["form_id"])
    
    #↓管理画面内に表示
    #render_custom_template @entry.form_id, "show"
    #render_entry
    #表のページプレビュー
    redirect_to contents_detail_preview_path(:name => @entry.form.template_name  , :id => params[:id])
  end
  
  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry = Entry.new
    @entry.updated_by = @entry.created_by = current_user
    #@entry.date_end = 1.years.from_now
    #@entry.status = "draft"
    @entry.form_id = params[:form_id]
    if @entry.form_id.blank?
      flash[:error] = 'カテゴリを選択してください。'
      redirect_to(entries_path)   
    else
      add_sub_menu(search_form["form_id"])
      respond_to do |format|
        format.html {render_custom_template( @entry.form_id, "edit") }
        format.xml  { render :xml => @entry }
      end
    end
  end
  
  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user_has_kousin_kengen?(current_user)
      @entry.preload_custom_fields
      add_sub_menu(search_form["form_id"])
      render_custom_template @entry.form_id, "edit"
    else
      flash[:error] = '権限がありません。'
      redirect_to :action => :index 
    end
  
  end
  
  # 
  #クリエイト
  #
  def create
    add_sub_menu(search_form["form_id"])
    @entry = Entry.new(params[:entry])
    
    @entry.updated_by = @entry.created_by = current_user
    button_action_name = get_submit_action
    errors = Entry.update_status(@entry,  button_action_name, current_user )
    respond_to do |format|
      Entry.transaction do
        
        begin
          if errors.empty? && @entry.save && @entry.save_entry_metas(params)
            @entry.after_all_save
            format.html {
              flash.now[:notice] = '保存されました。'
              
              render_custom_template( @entry.form_id, "edit")
            }
            
          else
            logger.debug "エラーが発生しました"              
            raise ActiveRecord::RecordInvalid, @entry       
            
            
            
          end
        rescue ActiveRecord::RecordInvalid => e
          format.html {
            flash.now[:error] = "エラー#{errors.join('')}"
            render_custom_template( @entry.form_id, "edit") 
          }
          raise ActiveRecord::Rollback
        end
        
      end
    end
  end
  
  # 
  #アップデート 
  #
  def update
    add_sub_menu(search_form["form_id"])
    @entry = Entry.find(params[:id])
    unless @entry.user_has_kousin_kengen?(current_user)
      flash[:error] = "権限がありません"
      return redirect_to :action => :index
    end
    @entry.updated_by =  current_user
    submit_action = get_submit_action
    if submit_action == "sakujo"
      _destroy
      return
    end
    
    errors = Entry.update_status(@entry, submit_action , current_user )
    respond_to do |format|
      
      Entry.transaction do
        
        begin
          if errors.empty? && @entry.update_attributes(params[:entry]) && @entry.save_entry_metas(params)
            @entry.after_all_save
            format.html { 
              flash.now[:notice] = '保存されました。'
              render_custom_template( @entry.form_id, "edit")
            }
            
            
          else
            logger.debug "エラーが発生しました"              
            raise ActiveRecord::RecordInvalid, @entry
            
          end
        rescue ActiveRecord::RecordInvalid => e
          format.html {
            flash.now[:error] = "エラー#{errors.join('')}"
            render_custom_template( @entry.form_id, "edit") 
            
          }
          raise ActiveRecord::Rollback
        end
      end
    end
  end
  
  # 
  # 削除
  def destroy
    _destroy
  end
  
  #
  #インポート
  #  
  def import
    add_sub_menu(search_form["form_id"])
    render_custom_template( search_form["form_id"], "import")
  end
  
  #
  #インポート
  #
  def import_post
    add_sub_menu(search_form["form_id"])
    name = params[:name]
    file = params[:up_file]
    if file.blank? || file.size <= 0
      flash.now[:error] = "ファイルサイズが0です"
      render_custom_template( search_form["form_id"], "import")
      return
    end
    
#    if name == "job"
#
#      
#    else
#      
#      flash.now[:error] = "不明なname:#{name}"
#      render :action => "import" 
#      return
#    end
    logger.info "インポート:#{name}"
    CustomImport.new.import(name,file, current_user)
    
    
    
    
    flash.now[:notice] = '実行されました。'
    render_custom_template( search_form["form_id"], "import")
  end
  
  
  private
  
  #
  #削除
  #
  def _destroy
    @entry = Entry.find(params[:id])
    unless @entry.user_has_kousin_kengen?(current_user)
      flash[:error] = "権限がありません"
      return redirect_to :action => :index
    end    
    #権限チェック
    errors = Entry.update_status(@entry, "sakujo", current_user)
    unless errors.empty?
      flash[:error] = "エラーが発生しました。#{errors.join('')}"
      redirect_to(entries_url)
      return
    end
    
    Entry.transaction do
      #@entry.entry_metas.each{|em|
       # em.destroy
      #}
      #紐づいたentry_metaと添付ファイルを自動的に削除
      @entry.destroy
      
    end
    
    respond_to do |format|
      format.html { redirect_to(entries_url, :notice => '削除されました。') }
      format.xml  { head :ok }
    end
    
  end
  
  #このコントローラ内部だけで使うセッションを返す
  def local_session
    session['entries_controller'] ||= { :default_status_filter => "draft" }
  end   
  
  #
  #フィルタ
  #
  def filtered_list(sql_params)
    
    
    
    entries = Entry.page(params[:page]).per(30).order("id DESC")
    
    if  (not sql_params["status"].blank?) and not sql_params["status"] == "all" 
      entries = entries.where("status = ?", sql_params["status"])
    end
    
    #all==ゴミ箱以外
    if sql_params["status"] == "all" 
      entries = entries.where("status <> ?", "trash")
    end
    
    if not sql_params["form_id"].blank?
      entries = entries.where("form_id = ?", sql_params["form_id"])
    end
    
    if sql_params["keyword"].present?
      entries = entries.where("title LIKE ?", "%#{sql_params["keyword"]}%")
    end
    
    #管理者以外は閲覧可能カテゴリが限られる
    unless current_user.has_privilege?
      entries = entries.where(:form_id => current_user.permitted_form_ids)
    end
    
    
    #自分が作成した記事のみ
    unless current_user.can_read_others_file?
      entries = entries.where("created_by_id = ? " , current_user.id)
    end
    
    entries
  end
  


  #
  #一括ゴミ箱移動
  #
  def move_to_trash(ids)
    return unless Array === ids
    error_strs = []
    Entry.where(:id => ids).each{|ent|
      
      errors = Entry.update_status(ent,"gomibako", current_user)
      unless errors.empty?
        error_strs << "#{ent.title}:#{errors.join('')}"
      else
        ent.save!
      end
    }
    unless error_strs.empty?
      flash.now[:error] =  error_strs.join(',')
    end
  end
  
  
  #
  #一括削除
  #
  def destroy_selected_items(ids)
    return unless Array === ids
    error_strs = []
    Entry.where(:id => ids).each{|ent|
      
      errors = Entry.update_status(ent,"sakujo", current_user)
      unless errors.empty?
        error_strs << "#{ent.title}:#{errors.join('')}"
      else
        ent.destroy
      end
    }
    unless error_strs.empty?
      flash.now[:error] =  error_strs.join(',')
    end
  end


  #
  #一括承認取り消し
  #
  def syounin_torikesi_selected_items(ids)
    return unless Array === ids
    error_strs = []
    Entry.where(:id => ids).each{|ent|
      
      errors = Entry.update_status(ent,"syounin_torikesi", current_user)
      unless errors.empty?
        error_strs << "#{ent.title}:#{errors.join('')}"
      else
        ent.save!
      end
    }
    unless error_strs.empty?
      flash.now[:error] =  error_strs.join(',')
    end
  end
  
  #
  #
  #
  def search_form
    @searchform = local_session[:searchform]
    @searchform ||= { "status" => "all" }  
    if params[:searchform]
      @searchform.merge!(params[:searchform])
    end
    if params[:category]
      @searchform["form_id"] = Form.where("template_name = ?", params[:category]).first.id
    end
    local_session[:searchform] = @searchform
    @searchform
  end
  
  #
  #サブメニュー
  #
  def add_sub_menu(selected_form_id)
    
    op = []
    op << AdminMenu.new({
           :title => "すべて", 
           :path => entries_path("searchform[form_id]" => ""      ),
            :selected => selected_form_id.blank?
    })
    current_user.browsable_forms.order("id").each do |frm|
      op << AdminMenu.new({
           :title => frm.title, 
           :path => entries_path("searchform[form_id]" => frm.id),
           :selected => selected_form_id && selected_form_id.to_i == frm.id
      })
    end    
    #p op
    admin_menu_list.sub_hash[:page].sub   = op
  end
  
  #
  #submitアクション名
  #
  def get_submit_action
    params[:submit_action].blank? ?  "fumeina_action" : params[:submit_action].keys.first
  end
  
  #
  #カスタムテンプレート描画
  #
  def render_custom_template(form_id, file_name)
    begin
      form = Form.where("id=?", form_id).first
      #raise EntriesController::MissingCustomTemplate.new unless form
      cat_name = form ?  form.template_name : "_all"
    
      custom_file = File.join("entries", cat_name, file_name)

      render :template => custom_file
    rescue ActionView::MissingTemplate => evar
      render :template => File.join("entries", file_name)
    end
  end
  
  #
  #カテゴリアクセス権限チェック
  #
  def category_permitted?(form_id)
    return true if form_id.blank?
    form_id = form_id.to_i
    #管理者以外は閲覧可能カテゴリが限られる
    if current_user.has_privilege?
      true
    else
      if current_user.permitted_form_ids.include? form_id
        true
      else
        false
      end
    end
   
  end
  
  class MissingCustomTemplate < StandardError
    
  end
end
