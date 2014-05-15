#coding:utf-8
require 'net/https'
module FBManager
  


  #fbによるログインプロセスを開始するためのURL
  def fb_login_url
    fb_auth_url_for(fb_callback_login_url)
  end
  
  #fbによるログイン機能を有効化するためのURL
  def fb_assoc_url
    fb_auth_url_for(fb_callback_assoc_user_profiles_url)
  end
  
  #fbによるサインアップを開始するためのURL
  def fb_signup_url
    fb_auth_url_for(fb_callback_signup_url)
  end

  
  #fbによるログイン(コールバック)
  def fb_callback_login
    code = params[:code]
    state = params[:state]
    if code.blank?
      #キャンセルされた場合もcodeはセットされない。
      flash[:error] = "キャンセルされました。"
      logger.info "code無しエラー"
      redirect_to fb_callback_fallback_path
      
    elsif form_authenticity_token !=  state
      flash[:error] = "CSRFエラー"
      redirect_to fb_callback_fallback_path
    else
      
      fb_access_token, expires = fb_get_access_token(code, fb_callback_login_url)
      if fb_access_token.blank?
        flash[:error] = "get_access_tokenエラー"
        redirect_to fb_callback_fallback_path        
      else
        u = fb_get_user_info(fb_access_token)
        p u
        #render :text => u.inspect
        create_session_with_fb(u)
      end
    end
  end
  
  #fbによるサインアップ(コールバック)
  def fb_callback_signup
    code = params[:code]
    state = params[:state]
    if code.blank?
      #キャンセルされた場合もcodeはセットされない。
      flash[:error] = "キャンセルされました。"
      logger.info "code無しエラー"
      redirect_to fb_callback_signup_fallback_path
      
    elsif form_authenticity_token !=  state
      flash[:error] = "CSRFエラー"
      redirect_to fb_callback_signup_fallback_path
    else
      
      fb_access_token, expires = fb_get_access_token(code, fb_callback_signup_url)
      if fb_access_token.blank?
        flash[:error] = "get_access_tokenエラー"
        redirect_to fb_callback_signup_fallback_path        
      else
        u = fb_get_user_info(fb_access_token)
        p u
        #render :text => u.inspect
        create_session_with_fb(u, {:create_user => true})
      end
    end
  end  
  
  #fbによるログイン機能を有効化するためのアクション(コールバック)
  def fb_callback_assoc
    code = params[:code]
    state = params[:state]
    @user = current_user
    if code.blank?
      flash[:error] = "キャンセルされました。"
      logger.info "code無しエラー"
      redirect_to edit_user_profile_path(:id => 1)
      
    elsif form_authenticity_token !=  state
      flash[:error] = "CSRFエラー"
      redirect_to edit_user_profile_path(:id => 1)
    else
      
      fb_access_token, expires = fb_get_access_token(code, fb_callback_assoc_user_profiles_url)
      if fb_access_token.blank?
        flash[:error] = "get_access_tokenエラー"
        redirect_to edit_user_profile_path(:id => 1)
      else
        fb_info = fb_get_user_info(fb_access_token)
        p fb_info
        #render :text => u.inspect
        #FaceBook IDとCMSのIDを結びつける
        fb_id = fb_info["id"]
         user = User.where(:fb_id => fb_id).first
         if user.present? && user.id != @user.id
           flash[:error] = "このFaceBook IDは既に他のアカウントに関連付けられています。"
           logger.info "このFaceBook ID(#{fb_id})は既に他のアカウントに関連付けられています。"
           redirect_to edit_user_profile_path(:id => 1)
           return
         end
         
        @user.fb_id = fb_id
        if @user.save
          flash[:notice] = 'FaceBookログインを有効にしました。'
          logger.info "FaceBookログインを有効にしました(#{@user.login})"
          redirect_to edit_user_profile_path(:id => 1)
        else
          flash[:error] = "user save エラー"
          render :action => :edit
        end
      end
    end
  end    
  
  #fbによるログイン機能を無効化するためのアクション
  def fb_assoc_cancel
    @user = current_user
    @user.fb_id = nil
    if @user.save
      flash.now[:notice] = 'FaceBookログインを無効にしました。'
    else
      flash.now[:error] = 'エラー'
    end
    render :action => "edit"
  end
  
  private
  #コードをアクセストークンに変換
  def fb_get_access_token(code, url)

#https://graph.facebook.com/oauth/access_token?
#    client_id=YOUR_APP_ID
#   &redirect_uri=YOUR_REDIRECT_URI
#   &client_secret=YOUR_APP_SECRET
#   &code=CODE_GENERATED_BY_FACEBOOKOK

    req_params = {
      "client_id"     => AppConfig.get('fb_app_id'),
      "redirect_uri"  => URI.encode_www_form_component(url),
      "client_secret" => AppConfig.get('fb_app_secret'),
      "code"          => code
    }
    
    
    req_path =  "/oauth/access_token?"  + req_params.map{|k,v| "#{k}=#{v}" }.join("&")
    p req_path
    https = Net::HTTP.new('graph.facebook.com',443)
    https.use_ssl = true
    ret = https.start {
      response = https.get(req_path)
      logger.info "応答:#{response.code}"
      if response.code == "200"
        logger.info "成功:#{response.body}"
        hs = {}
        response.body.split('&').map{|pair|  
          k, v = pair.split("=")
          hs[k] = v
        }
       [ hs["access_token"], hs["expires"]  ] 
      else
        logger.info "失敗:#{response.body}"
        []
      end
    }
    ret
    #access_token=xxxx&expires=5176043
    
  end
  
  #ユーザー情報の取得
  def fb_get_user_info(access_token)
    https = Net::HTTP.new('graph.facebook.com',443)
    req_path = "/me?access_token=#{access_token}&locale=ja_JP"
    
    https.use_ssl = true
    ret = https.start {
      response = https.get(req_path)
      logger.info "応答:#{response.code}"
      if response.code == "200"
        logger.info "成功:#{response.body}"
        ActiveSupport::JSON.decode(response.body)
      else
        logger.info "失敗:#{response.body}"
        nil
      end
    }
    ret
  end


  #fbでログインセッションを作成
  def create_session_with_fb(fb_info, options = {})
    fb_id = fb_info["id"]
    user = User.where(:fb_id => fb_id).first
    if user.blank?
      if options[:create_user]
        user = create_guest_user_with_fb_id(fb_id)
      else
        #flash[:error] = "fb_idがCMSアカウントと関連付けられていません。"
        #return redirect_to new_user_session_path
        #初めてのログインで、関連付けされたCMSアカウントが存在しない場合、新規作成する
        logger.info "fb_idがCMSアカウントと関連付けられていません。"
        return redirect_to mypage_signup_path
      end
    end
    
    @user_session = UserSession.create(user)
    if @user_session && current_user
      after_login
    else
      logger.info "ログインできません"
      flash.now[:error] =  "ログインできません"
      render :action => :new
    end
  
  end

  #
  #FaceBook IDでゲストユーザーの作成
  #
  def create_guest_user_with_fb_id(fb_id)
    base_user = User.where("name LIKE ?", "guest%").order("name DESC").limit(1).first
    base_name = base_user.blank? ? "guest1" : base_user.name
    user = User.new
    user.fb_id = fb_id
    user.name = user.login = base_name.succ
    user.password = user.password_confirmation = User.generate_password
    #カテゴリアクセス許可
    forms = Form.where("template_name = ?", AppConfig.get('fb_user_permitted_form_name'))#"model_course")
    raise "AppConfig.get('fb_user_permitted_form_name')カテゴリが存在しません" if forms.blank?
    user.permitted_forms = forms
    user.save!
    logger.info "create_guest_user_with_fb_id(#{fb_id}):#{user}"
    user
  end


  #
  #
  #
  def fb_auth_url_for(url)
    #https://www.facebook.com/dialog/oauth?client_id=311158882320848&redirect_uri=http%3A%2F%2F192.168.252.59%2F2119
    
    
    #FBManager.get_access_token
    
    state = URI.encode_www_form_component(form_authenticity_token)
    
    p "https://www.facebook.com/dialog/oauth?client_id=#{AppConfig.get('fb_app_id')}&redirect_uri=" + 
      URI.encode_www_form_component(url) + "&state=#{state}"
  end
  
  #
  #
  #
  def fb_callback_signup_fallback_path
    mypage_signup_path
  end
  
  #
  #ログイン失敗時の遷移先
  #
  def fb_callback_fallback_path
    new_user_session_path
  end
  
end