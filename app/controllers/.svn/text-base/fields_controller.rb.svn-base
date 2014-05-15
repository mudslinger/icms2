#coding:utf-8
class FieldsController < ApplicationController
  # GET /fields
  # GET /fields.xml
  def index
    @fields = Field.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fields }
    end
  end

  # GET /fields/1
  # GET /fields/1.xml
  def show
    @field = Field.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @field }
    end
  end

  # GET /fields/new
  # GET /fields/new.xml
  def new
    @field = Field.new
    @field.form_id = params[:form_id]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @field }
    end
  end

  # GET /fields/1/edit
  def edit
    @field = Field.find(params[:id])
  end

  # POST /fields
  # POST /fields.xml
  def create
    @field = Field.new(params[:field])

    respond_to do |format|
      if @field.save
        @field.sortkey = @field.id
        @field.save!
        
        format.html { redirect_to(edit_form_path(@field.form_id), :notice => 'フィールドが追加されました') }
        format.xml  { render :xml => @field, :status => :created, :location => @field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /fields/1
  # PUT /fields/1.xml
  def update
    @field = Field.find(params[:id])
    Field.transaction do
      respond_to do |format|
        if params[:update_order]
          update_order(params[:update_order],params[:form_id])
          
        end
        
        
        if @field.update_attributes(params[:field])
          format.html { redirect_to(edit_form_path(@field.form_id), :notice => 'フィールドが更新されました。') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @field.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /fields/1
  # DELETE /fields/1.xml
  def destroy
    @field = Field.find(params[:id])
    @field.destroy

    respond_to do |format|
      format.html { redirect_to(edit_form_path(@field.form_id)) }
      format.xml  { head :ok }
    end
  end
  
  
  private
  def update_order(up_down, form_id)
    form = Form.find(form_id)
    idx = form.fields.index(@field)
    to_idx = nil
    case up_down
      when "up"
        to_idx = idx - 1
    when "down"
      to_idx = idx + 1
    end
    
    if to_idx < 0 || to_idx > form.fields.size - 1
      return
    end
    arr = form.fields
    field_to_move = arr[to_idx]
    arr[to_idx] =  @field
    arr[idx] = field_to_move
    arr.each_with_index do |field,i|
      field.sortkey = "#{i+1}"
      field.save!
    end
  end
  
end
