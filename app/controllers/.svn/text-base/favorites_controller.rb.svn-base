#coding:utf-8
class FavoritesController < ApplicationController
  # GET /favorites
  # GET /favorites.json
  layout "mypage"
  

  include ContentsRenderer
  
  helper_method :entries_for_monthly_archives, :headline, :cf_filter
  
  def index
    
    @favorites = Favorite.user_favorites(current_user).
      order("ID DESC").page(params[:page]) #.per(3)
    #@entries = Entry.where_valid_article.joins("INNER JOIN my_lists ON entries.id=my_lists.entry_id AND my_lists.user_id = #{current_user.id}").order("ID DESC")
    @entries = filtered_list({})
    respond_to do |format|
      format.html
     # format.json { render json: @my_lists }
    end
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @favorite }
    end
  end

  # GET /favorites/new
  # GET /favorites/new.json
  def new
    @favorite = Favorite.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @favorite }
    end
  end

  # GET /favorites/1/edit
  def edit
    @favorite = Favorite.find(params[:id])
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(params[:favorite])

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite, notice: 'Favorite was successfully created.' }
        format.json { render json: @favorite, status: :created, location: @favorite }
      else
        format.html { render action: "new" }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /favorites/1
  # PUT /favorites/1.json
  def update
    @favorite = Favorite.find(params[:id])

    respond_to do |format|
      if @favorite.update_attributes(params[:favorite])
        format.html { redirect_to @favorite, notice: 'Favorite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_to favorites_url , notice: '削除しました。'}
      format.json { head :no_content }
    end
  end
  
  #
  #
  #
  def add
    entry_id = params[:entry_id]
    raise "no entry id" if entry_id.blank?
    respond_to do |format|
      
      if not Entry.where_valid_article.where(:id => entry_id).exists?
        logger.debug 'この記事は登録できません。'
        format.html { 
          redirect_to favorites_path, 
          notice: 'この記事は登録できません。' 
        }
        
      elsif Favorite.where(:entry_id => entry_id, :user_id => current_user.id).exists?
        logger.debug '既に登録されています。'
        format.html { 
          redirect_to favorites_path, notice: 'この記事は既に登録されています。'

        }
        
      else
        @favorite = Favorite.new
        @favorite.user_id = current_user.id
        @favorite.entry_id = entry_id
        if @favorite.save
          format.html {
            logger.debug 'マイページに登録しました。'
            redirect_to favorites_path, notice: 'マイページに追加しました。' 
          }
        else
          format.html { redirect_to favorites_path, error: 'エラーが発生しました。' }
        end
  
      end
      
      
      
    end
    
  end
  



  private
  #
  #ログインしていないとき、ログインを促す画面に遷移する。そのリダイレクト先URLを返す
  #オーバーライド用
  def url_for_login_required
    #"http://www.izumo.ne.jp/"
    #fb_login_url
    mypage_login_path
  end  
  
  
  #
  #フィルタ
  #
  def filtered_list(sql_params)
    
    
    
    entries = Entry.page(params[:page_entries]).order("id DESC") #.per(30)
    entries = entries.where(:form_id => Form.where(:template_name => AppConfig.get('fb_user_permitted_form_name')).pluck(:id))
    
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
    #unless current_user.has_privilege?
     # entries = entries.where(:form_id => current_user.permitted_form_ids)
    #end
    
    
    #自分が作成した記事のみ
    #unless current_user.can_read_others_file?
      entries = entries.where("created_by_id = ? " , current_user.id)
    #end
    
    entries
  end  
  


end
