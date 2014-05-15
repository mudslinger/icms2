#coding:utf-8
class CmsUser < User
  def serializable_hash(options = nil)
    hash = super
    #p hash
    hash[:category] = @category_names
    hash
  end
  
  def load_categories!
    @category_names = permitted_forms.map{|form| form.template_name  }
  end
  
  def category_names=(category_names)
    ids = []
    @category_names = category_names
    @category_names ||= []
    @category_names.each do |category_name|
      frm = Form.where("template_name=?", category_name).first
      if frm.blank?
        logger.error "そのようなカテゴリ名は存在しません:#{category_name}"
      else
        ids << frm.id
      end
    end
    self.permitted_form_ids = ids
  end
  
end

class CmsUsersController < ApplicationController
  skip_before_filter :login_required
  before_filter :auth
  
  
  
  # GET /users
  # GET /users.xml
  def index
    @users = CmsUser.order(:id)
    params.each{|k,v|
    case k
      when "login","name","user_level","emailaddress"
        @users = @users.where("#{k}=?", v)
     end
    }

    @users.each{|user|
      user.load_categories!
    }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = CmsUser.find(params[:id])
    @user.load_categories!
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.json { render :json  => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = CmsUser.new
    @user.load_categories!
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = CmsUser.find(params[:id])
    @user.load_categories!
  end

  # POST /users
  # POST /users.xml
  def create
    category_names = params[:cms_user].delete(:category)
    @user = CmsUser.new_default_user(params[:cms_user])
    @user.password_confirmation = @user.password
    @user.login_count = 0
    @user.category_names = category_names 
    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path, :notice => 'ユーザーを作成しました。') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render :json => @user, :status => :created, :location => @user }

      else
        logger.error @user.errors.full_messages
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = CmsUser.find(params[:id])
    params[:cms_user][:password_confirmation] = params[:cms_user][:password]
    @user.category_names = params[:cms_user].delete(:category)


    respond_to do |format|
      if @user.update_attributes(params[:cms_user])
        format.html { redirect_to(users_path, :notice => 'ユーザーを更新しました。') }
        format.xml  { head :ok }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = CmsUser.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
      format.json { head :no_content }
    end
  end
  
  private
  def auth
    authenticate_or_request_with_http_basic do |user, pass|
      #user == 'api_user' && pass == 'api_pass'
      user_param ={ :login => user , :password => pass }
      user_session = UserSession.new(user_param)
      if user_session.save && current_user      
        true
      else
        false
      end
    end
  end
  
end
