#coding:utf-8
class MyEntriesController < ApplicationController
  layout "mypage"
  
  #cache_sweeper :contents_cache_sweeper
  #↓表のページのentries_for_monthly_archivesを使うため、必要
  include ContentsRenderer
  
  helper_method :entries_for_monthly_archives  , :headline, :cf_filter

  before_filter :my_entires_filter
  private 
  def my_entires_filter
    @entry_picker_path = File.join(root_path, "entry_picker2")
  end
  public
  
  def new
    
    
    @entry = Entry.new
    @entry.form_id = Form.where(:template_name => AppConfig.get("fb_user_permitted_form_name")).first.id #current_user.permitted_forms.first.id
    render :action => :edit
  end
  
  def edit
    @entry = Entry.find(params[:id])
    if @entry.user_has_kousin_kengen?(current_user)
      @entry.preload_custom_fields
      render_custom_template @entry.form_id, "edit"
    else
      flash[:error] = "権限がありません"
      redirect_to favorites_path
    end
  end
  
  
  # 
  #クリエイト
  #
  def create
    
    @entry = Entry.new(params[:entry])
    
    @entry.updated_by = @entry.created_by = current_user
    #button_action_name = get_submit_action
    #最初から公開状態にする
    errors = [] # Entry.update_status(@entry,  button_action_name, current_user )
    @entry.status = 'publish'
    respond_to do |format|
      Entry.transaction do
        
        begin
          if errors.empty? && @entry.save && @entry.save_entry_metas(params)
            @entry.after_all_save
            format.html {
              flash.now[:notice] = '保存されました。'
              
              #render_custom_template( @entry.form_id, "edit")
              redirect_to favorites_path
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
    
    @entry = Entry.find(params[:id])
    unless @entry.user_has_kousin_kengen?(current_user)
      flash[:error] = "権限がありません"
      return redirect_to favorites_path      
    end
    
    @entry.updated_by =  current_user
    #submit_action = get_submit_action

    
    errors = [] #Entry.update_status(@entry, submit_action , current_user )
    respond_to do |format|
      
      Entry.transaction do
        
        begin
          if errors.empty? && @entry.update_attributes(params[:entry]) && @entry.save_entry_metas(params)
            @entry.after_all_save
            format.html { 
              flash.now[:notice] = '保存されました。'
              #render_custom_template( @entry.form_id, "edit")
              redirect_to favorites_path
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
  
  
  def destroy
    @entry = Entry.find(params[:id])
    unless @entry.user_has_kousin_kengen?(current_user)
      flash[:error] = "権限がありません"
      return redirect_to favorites_path      
    end
    @entry.destroy
     redirect_to favorites_path, :notice => "削除されました。"
  end
  
  #
  #カスタムテンプレート描画
  #
  def render_custom_template(form_id, file_name)
    render :action => file_name
  end  
  
  #
  #submitアクション名
  #
  def get_submit_action
    params[:submit_action].blank? ?  "fumeina_action" : params[:submit_action].keys.first
  end  
  
  
  #
  #ログインしていないとき、ログインを促す画面に遷移する。そのリダイレクト先URLを返す
  #オーバーライド用
  def url_for_login_required
    #"http://www.izumo.ne.jp/"
    #fb_login_url
    mypage_login_path
  end    
end
