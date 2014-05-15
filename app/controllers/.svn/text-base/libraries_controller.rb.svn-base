#coding:utf-8
class LibrariesController < ApplicationController
  # GET /libraries
  # GET /libraries.xml
  def index
    @libraries = Library.page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @libraries }
    end
  end

  # GET /libraries/1
  # GET /libraries/1.xml
  def show
    @library = Library.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @library }
    end
  end

  # GET /libraries/new
  # GET /libraries/new.xml
  def new
    @library = Library.new
    @library.created_by = @library.updated_by = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @library }
    end
  end

  # GET /libraries/1/edit
  def edit
    @library = Library.find(params[:id])
  end

  # POST /libraries
  # POST /libraries.xml
  def create
    @library = Library.new(params[:library])
    @library.created_by = current_user
    @library.updated_by = current_user

    @library.file = params[:library][:file_path]

    respond_to do |format|
      if @library.save
        format.html { redirect_to(@library, :notice => 'Library was successfully created.') }
        format.xml  { render :xml => @library, :status => :created, :location => @library }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @library.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /libraries/1
  # PUT /libraries/1.xml
  def update
    @library = Library.find(params[:id])
    @library.updated_by = current_user
    @library.file = params[:library][:file_path]
    respond_to do |format|
      if @library.update_attributes(params[:library])
        format.html { redirect_to(@library, :notice => 'Library was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @library.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.xml
  def destroy
    @library = Library.find(params[:id])
    @library.destroy

    respond_to do |format|
      format.html { redirect_to(libraries_url) }
      format.xml  { head :ok }
    end
  end
  

  
end
