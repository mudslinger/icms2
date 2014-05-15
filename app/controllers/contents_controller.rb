#coding:utf-8

class ContentsController < ApplicationController
  include ContentsRenderer
  # jpmobileのテンプレート自動振り分け機能
  #include Jpmobile::ViewSelector
  
  helper_method :headline, :cf_filter, :entries_for_monthly_archives
  
  #ログインを必要としない
  skip_before_filter :login_required
  
  before_filter :force_plain
  
  #キャッシュ
  #caches_page :show
  #caches_page :index
  #caches_page :top
  
  layout "contents/common.html.erb"

  
  
  #
  #一覧表示
  #
  def index
    
    _index
  end

  #
  #一覧表示(印刷)
  #
  def index_print
    
    _index
  end  
  
  #
  #詳細表示
  #
  def show
    unless category_exists?(params[:name])
      logger.info "存在しないカテゴリにアクセスしようとした:#{params[:name]}"
      render_no_article
      return
    end
    
    
    @entry = Entry.where_valid_article.where(:id => params[:id]).first
    if @entry
      @entry.preload_custom_fields
      render_entry
    else
     render_no_article
     return
      
    end


  end

  def show_preview
    #本来ならentries_controllerに記述すべきであったが、
    #テンプレートにrender 'header'という記述をしたため
    #コントローラに依存してしまった＆修正が大変なのでここに書くことにした
    unless current_user
       render_no_article
       return
    end
    @entry = Entry.find(params[:id])
    @entry.preload_custom_fields
    render_entry    
  end
  
  
  #
  #topページ
  #
  def top
    
    hst = request.host
    case hst
      when /yamaokaya\-corp/, /yamaokaya\.jp/, /c59\.lan\.izumo\.ne\.jp/, /yamaokaya2\-corp/
        #params[:name] = "corporate"
        render_static "corporate/index"
        return
    end    
    
    #@topics = headline("topics")
    render_top
  end
  
  #
  #DBの絡まないページ
  #
  def static
    other =  params[:other]

    logger.debug "あざー #{other}"
    render_static other
  end
  
  
  def spelling
     redirect_to contents_index_url(:name => params[:name])
  end
 
 
  #アーカイブ
  def monthly_archives
    name = params[:name]
    unless category_exists?(name)
      logger.info "存在しないカテゴリにアクセスしようとした:#{name}"
      render_no_article
      return
    end
    year = params[:year].to_i
    month = params[:month].to_i
    date_field_name = params[:date_field_name]
    
    @entries = @entries_for_monthly_archives = entries_for_monthly_archives(name, date_field_name, year, month)   
    render_monthly_archives(name)
  end
  
#  def destroy_cache
#    logger.debug "呼ばれたdestroy_cache"
#    id = params[:id]
#    expire_page "/akiya_bank/#{id}"
#    logger.debug "呼ばれたafter destroy_cache"
#    redirect_to root_path
#  end
  
#  def search
#    if params[:button_search] #検索ボタンが押された
#      
#      elsif params[:button_reset] #リセットボタンが押された
#      
#      
#    end    
#  end
  
  
  private
  
  #
  #「記事が存在しません」表示
  #  
  def render_no_article
    render "not_found", :handlers => [:erb], :formats => [:html], :status => 404, :layout => nil
  end
  
  
  #
  #カテゴリが存在するか
  #  
  def category_exists?(name)
    Form.exists?(:template_name => name)
  end
  
  #
  #
  #  
  def _index
    unless category_exists?(params[:name])
      logger.info "存在しないカテゴリにアクセスしようとした:#{params[:name]}"
      render_no_article
      return
    end
    
    name = params[:name]
    form = Form.where("template_name = ?", name).first
    
    @entries = Entry.where_valid_article.page(params[:page]).order("id DESC").
      where("form_id=? ", form.id)
      

    render_entry_index(name)    
  end
  

  
end
