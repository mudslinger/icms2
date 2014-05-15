#coding:utf-8
class EntryMetasController < ApplicationController
  # GET /entry_metas
  # GET /entry_metas.xml
  def index
    @entry_metas = EntryMeta.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entry_metas }
    end
  end

  # GET /entry_metas/1
  # GET /entry_metas/1.xml
  def show
    @entry_meta = EntryMeta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry_meta }
    end
  end

  # GET /entry_metas/new
  # GET /entry_metas/new.xml
  def new
    @entry_meta = EntryMeta.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entry_meta }
    end
  end

  # GET /entry_metas/1/edit
  def edit
    @entry_meta = EntryMeta.find(params[:id])
  end

  # POST /entry_metas
  # POST /entry_metas.xml
  def create
    @entry_meta = EntryMeta.new(params[:entry_meta])

    respond_to do |format|
      if @entry_meta.save
        format.html { redirect_to(@entry_meta, :notice => 'Entry meta was successfully created.') }
        format.xml  { render :xml => @entry_meta, :status => :created, :location => @entry_meta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @entry_meta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entry_metas/1
  # PUT /entry_metas/1.xml
  def update
    @entry_meta = EntryMeta.find(params[:id])

    respond_to do |format|
      if @entry_meta.update_attributes(params[:entry_meta])
        format.html { redirect_to(@entry_meta, :notice => 'Entry meta was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry_meta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_metas/1
  # DELETE /entry_metas/1.xml
  def destroy
    @entry_meta = EntryMeta.find(params[:id])
    @entry_meta.destroy

    respond_to do |format|
      format.html { redirect_to(entry_metas_url) }
      format.xml  { head :ok }
    end
  end
end
