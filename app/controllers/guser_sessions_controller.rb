#coding:utf-8
class GuserSessionsController < ApplicationController
  layout "mypage"
  
  include FBManager
  include LoginProcess
  #↓表のページのentries_for_monthly_archivesを使うため、必要
  include ContentsRenderer
  
  helper_method :entries_for_monthly_archives , :headline, :cf_filter
  
  skip_before_filter :login_required #, :only => [:login, :signup, :fb_callback_signup]
  helper_method :fb_login_url, :fb_signup_url
  
  #
  #
  #
  def login
  end

  #
  #
  #
  def signup
  end

  #
  #ログアウト
  #
  def destroy
    current_user_session && current_user_session.destroy
    session && session.clear
    logger.info "ログアウトしました(GuserSessionsController)"
    redirect_to root_path , :notice => "ログアウトしました"
  end


  private
  #
  #ログイン失敗時の遷移先
  #
  def fb_callback_fallback_path
    mypage_login_path
  end

  #
  #ログイン処理終了後、最初に表示する画面のURL
  #
  def path_for_logged_in_user
    session.delete(:request_uri_on_session_time_out) || favorites_path
  end    


end