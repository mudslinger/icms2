#coding:utf-8
class RfilesController < ApplicationController
  layout "popup.html.erb"
  # GET /libraries
  # GET /libraries.xml
  def index
    @rfiles = Rfile.page(params[:page]).per(10).order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /libraries/1
  # GET /libraries/1.xml
  def show
    @rfile = Rfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /libraries/new
  # GET /libraries/new.xml
  def new
    @rfile = Rfile.new
    @rfile.created_by = @rfile.updated_by = current_user

    respond_to do |format|
      format.html # new.html.erb
      #render :action => "edit"
    end
  end

  # GET /libraries/1/edit
  def edit
    @rfile = Rfile.find(params[:id])
  end

  # POST /libraries
  # POST /libraries.xml
  def create
    @rfile = Rfile.new(params[:rfile])
    @rfile.created_by = current_user
    @rfile.updated_by = current_user

    @rfile.file = params[:rfile][:file_path]

    respond_to do |format|
      if @rfile.save
        format.html { 
          #redirect_to(rfile_show_path(@rfile.id), :notice => 'Rfile was successfully created.') 
          render :action => "edit"
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # PUT /libraries/1
  # PUT /libraries/1.xml
  def update
    @rfile = Rfile.find(params[:id])
    @rfile.updated_by = current_user
    @rfile.file = params[:rfile][:file_path]
    respond_to do |format|
      if @rfile.update_attributes(params[:rfile])
        format.html { 
          #redirect_to(@rfile, :notice => 'Rfile was successfully updated.')
          flash.now[:notice] = "更新されました"
          render :action => "edit"
          #redirect_to edit_rfile_path(@rfile ) 
         }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.xml
  def destroy
    @rfile = Rfile.find(params[:id])
    @rfile.destroy

    respond_to do |format|
      format.html { redirect_to(rfiles_url) }
    end
  end
  

  
end
