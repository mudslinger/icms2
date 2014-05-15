#coding:utf-8

class UserSessionsController < ApplicationController
  skip_before_filter :site_protected
  skip_before_filter :login_required, :only => [:new, :create, :forward, :fb_callback]
  layout "login"
  
  include FBManager
  include LoginProcess
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save && current_user
      after_login
    else
      logger.info "ログインできません"
      flash.now[:error] =  "ログインできません"
      render :action => :new
    end
  end
  

  
  
  
  def destroy
    current_user_session.destroy
    session.clear
    #session.destroy
    logger.info "ログアウトしました"
    redirect_to new_user_session_path , :notice => "ログアウトしました"
    #※セッションを破棄してもcsrf_meta_tagやフラッシュメッセージのためにセッションが再作成される
    #redirect_to new_user_session_path 
    #redirect_to root_path , :notice => "ログアウトしました"

  end


  def forward
    #unless AppConfig.get("forward")
     # raise "設定でforwardが無効になっています。"
    #end
    
    user_param ={ :login => params[:usid] , :password => params[:pass] } 

#    user = User.where("login=?", params[:usid]).first
#    unless user
#      #ユーザーが存在しないなら作成
#      logger.info "ユーザーが存在しないので作成#{user_param}"
#      user = User.new_default_user(user_param)
#      user.name = user_param[:login]
#      user.permitted_forms = Form.all
#      unless user.save
#        flash.now[:error] = "ユーザーの作成に失敗"
#        @record = user
#        return render :template => "global/error", :layout => "global"
#      end
#    end
    
    
    @user_session = UserSession.new(user_param)
    if @user_session.save && current_user
      logger.info "ログインしました:#{current_user.login}"
      logger.info "forward=#{params[:url]}"
      unless params[:css].blank?
        session[:custom_stylesheet] = "custom/#{params[:css]}"   
      end
      redirect_to File.join(root_path, "#{params[:url]}")
      
    else
      logger.info "ログインできません"
      flash.now[:error] = "ログインできません"
      render :template => "global/error", :layout => "global"
    end
    
  end
  
  helper_method :fb_login_url
  
  private
  

  

  
end
