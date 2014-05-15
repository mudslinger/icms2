#coding:utf-8
class FormsController < ApplicationController
  before_filter :permission_required
  # GET /forms
  # GET /forms.xml
  def index
    @forms = Form.page(params[:page]).per(30)

    if params[:entry_form_type_chooser]
      render :template => "forms/chooser.html.erb"
       return
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forms }
    end
  end


  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    if params[:copy]
      id = copy(params[:id])
      redirect_to edit_form_path(id), :notice => 'コピーしました'
      return 
    end
    
    @form = Form.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/1/edit
  def edit
    @form = Form.find(params[:id])
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = Form.new(params[:form])

    respond_to do |format|
      if @form.save
        directory_setup
        format.html { redirect_to(edit_form_path(@form), :notice => 'カテゴリが登録されました。') }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    @form = Form.find(params[:id])
    unless params[:sorted_field_ids].blank?
      params[:sorted_field_ids].split(',').each_with_index{|ele,i|
        id = ele[/\d+$/]
        fld = @form.fields.find(id.to_i)
        fld.sortkey = sprintf("%04d", i * 10)
        fld.save!
      }
    end

    respond_to do |format|
      if @form.update_attributes(params[:form])
        format.html { redirect_to(forms_path, :notice => 'カテゴリが更新されました。') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.xml
  def destroy
    @form = Form.find(params[:id])
    if @form.entries.count > 0
      #キャッシュスイープでエラーになるので手動で削除してもらう。
      flash[:error] = "データが存在します"
      redirect_to(forms_path)
      return
    end
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(forms_url) }
      format.xml  { head :ok }
    end
  end
  
  def download
    entries = Entry.where("form_id =? ", params[:form_id]).order("id DESC")
    respond_to do |format|
      format.csv {
        
        send_data Entry.csvdata(entries, Form.find(params[:form_id])), 
        :type => "application/octet-stream", 
        :disposition => "attachment; filename=data_#{params[:form_id]}.csv"
      }    
    end
  end
  
  private 
  def copy(from_id)
    Form.transaction do
      org_form  = Form.find(from_id)
      
      attr = org_form.attributes
      attr.delete("id")
      attr.delete("created_at")
     
      @form = Form.new( attr ) 
      @form.title = "#{@form.title}2"
      @form.template_name = "#{@form.template_name}2"
      @form.save!
      
      org_form.fields.each{|org_field|
        
        attr2 = org_field.attributes
        attr2.delete("id")
        attr2.delete("created_at")
        field = Field.new(attr2)
        
        
        @form.fields << field
      }
      
      @form.id
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
  
  #
  #doc/default_template/_default 以下をコピーする
  #
  def directory_setup
    contents_dir = File.join(Rails.root, "app", "views", "contents" )
    category_dir = File.join(contents_dir, @form.template_name)
    unless File.exists?(category_dir )
      FileUtils.mkdir(category_dir )
    end
    
    template_dir = File.join(Rails.root, "doc", "default_template", "_default")
    
    
    Dir.glob(File.join(template_dir, "*") ).each do |fn|
      dst_file = File.join(category_dir, File.basename(fn) )
     unless File.exists?(dst_file)
       FileUtils.cp fn, dst_file
     end
    end
  end
 
  
end
