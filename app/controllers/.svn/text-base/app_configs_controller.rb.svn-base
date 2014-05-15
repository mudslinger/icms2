#coding:utf-8
class AppConfigsController < ApplicationController
  # GET /app_configs
  # GET /app_configs.xml
  def index
    @app_configs = AppConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @app_configs }
    end
  end

  # GET /app_configs/1
  # GET /app_configs/1.xml
  def show
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app_config }
    end
  end

  # GET /app_configs/new
  # GET /app_configs/new.xml
  def new
    @app_config = AppConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app_config }
    end
  end

  # GET /app_configs/1/edit
  def edit
    @app_config = AppConfig.find(params[:id])
  end

  # POST /app_configs
  # POST /app_configs.xml
  def create
    @app_config = AppConfig.new(params[:app_config])

    respond_to do |format|
      if @app_config.save
        format.html { redirect_to(@app_config, :notice => 'App config was successfully created.') }
        format.xml  { render :xml => @app_config, :status => :created, :location => @app_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /app_configs/1
  # PUT /app_configs/1.xml
  def update
    @app_config = AppConfig.find(params[:id])

    respond_to do |format|
      if @app_config.update_attributes(params[:app_config])
        format.html {
          flash.now[:notice] = "更新しました。"
          render :action => "edit" 
          #redirect_to(@app_config, :notice => 'App config was successfully updated.') 
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /app_configs/1
  # DELETE /app_configs/1.xml
  def destroy
    @app_config = AppConfig.find(params[:id])
    @app_config.destroy

    respond_to do |format|
      format.html { redirect_to(app_configs_url) }
      format.xml  { head :ok }
    end
  end
  
  def extra
    
  end
end
