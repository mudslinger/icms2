#coding:utf-8

module LoginProcess
  private
  def after_login
    init_session
    logger.info "ログインしました:#{current_user.login}"
    logger.info "Agent=#{request.env['HTTP_USER_AGENT']}"
    current_user.user_agent = request.env['HTTP_USER_AGENT']
    current_user.save
    ActionLog.new({ :name => "login", :message => "#{current_user.name}(#{current_user.login})がログインしました。" }).save
    redirect_to path_for_logged_in_user , :notice => "ログインしました"    
  end
  
  def init_session
    #セッションに残った古い情報削除
    session.delete :custom_stylesheet
  end
  #
  #ログイン処理終了後、最初に表示する画面のURL
  #
  def path_for_logged_in_user
    session.delete(:request_uri_on_session_time_out) || admin_menu_path
  end  
end


class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  #hankaku_filter 
  before_filter :site_protected
  before_filter :login_required
  protect_from_forgery
  
  
  helper_method :current_user_session, :current_user, :admin_menu_list
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def login_required
    unless current_user
      session[:request_uri_on_session_time_out] = request.env["REQUEST_URI"]
      redirect_to url_for_login_required, :notice => 'ログインが必要です。'
      return false
    end
  end
  
  
  def site_protected
    if AppConfig.maintenance_mode?
      unless current_user
        response.status = 503
        render :template => "contents/maintenance", :layout => nil
        return false
      end
    end
  end
  
  #
  #メニュー
  #
  def admin_menu_list
    unless @admin_menu_list
      
      top_menues = {}
      top_menues[:page] = AdminMenu.new({
           :title => "ページ", :path => entries_path
        })
    if current_user.has_privilege?  
      top_menues[:form] = AdminMenu.new({
           :title => "カテゴリ設定", :path => forms_path
        })
      top_menues[:user] = AdminMenu.new({
           :title => "ユーザー", :path => users_path
        })
        
      top_menues[:administration] = AdminMenu.new({
           :title => "管理", :path => "#",
           :sub => [
              AdminMenu.new({:title => "メンテナンス", :path => edit_app_config_path(:id => 1) }),
              AdminMenu.new({:title => "ログ", :path => action_logs_path }),
            ]
        })
        
       
     end   
      if current_user.login == "kawahara"
        top_menues[:lib] = AdminMenu.new({
           :title => "その他", :path => admin_extra_menu_path
        })        
#        top_menues[:lib] = AdminMenu.new({
#           :title => "lib", :path => libraries_path
#        })
#        
#        top_menues[:admin] = AdminMenu.new({
#           :title => "キャッシュクリア", :path => admin_sweep_cache_path
#        })
#        top_menues[:trig] = AdminMenu.new({
#           :title => "トリガー", :path => admin_triggers_sweep_cache_path
#        })
#        top_menues[:reload] = AdminMenu.new({
#           :title => "リロード", :path => admin_app_reload_path
#        })
        
      end
      
      root = AdminMenu.new({
       :sub_hash => top_menues,
      :sub => top_menues.values,
      
      }
      )
      @admin_menu_list = root
    end
    @admin_menu_list
  end
  
  
  #
  #ログインしていないとき、ログインを促す画面に遷移する。そのリダイレクト先URLを返す
  #オーバーライド用
  def url_for_login_required
    new_user_session_url
  end
  
end
