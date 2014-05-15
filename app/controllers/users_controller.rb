#coding:utf-8
class UsersController < ApplicationController
  before_filter :permission_required
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.page(params[:page]).per(30)
    
    unless current_user.has_privilege?
      #自分自身
      @users = @users.where("id=?", current_user.id)
    end
  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.login_count = 0
    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path, :notice => 'ユーザーを作成しました。') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(users_path, :notice => 'ユーザーを更新しました。') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user.id == current_user.id
      return redirect_to(users_url, :notice => "自分を削除することはできません。")
    end
    @user.destroy


    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  def permission_required
    unless current_user.has_privilege?
      #redirect_to admin_menu_path, :notice => '権限が必要です。'
      flash.now[:error] = "権限がありません"
      render :template => 'global/error'
    end
  end
  
end
