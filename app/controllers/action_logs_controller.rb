class ActionLogsController < ApplicationController
  # GET /action_logs
  # GET /action_logs.json
  def index
    @action_logs = ActionLog.page(params[:page]).per(30).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @action_logs }
    end
  end

  # GET /action_logs/1
  # GET /action_logs/1.json
  def show
    @action_log = ActionLog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @action_log }
    end
  end

  # GET /action_logs/new
  # GET /action_logs/new.json
  def new
    @action_log = ActionLog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @action_log }
    end
  end

  # GET /action_logs/1/edit
  def edit
    @action_log = ActionLog.find(params[:id])
  end

  # POST /action_logs
  # POST /action_logs.json
  def create
    @action_log = ActionLog.new(params[:action_log])

    respond_to do |format|
      if @action_log.save
        format.html { redirect_to @action_log, notice: 'Action log was successfully created.' }
        format.json { render json: @action_log, status: :created, location: @action_log }
      else
        format.html { render action: "new" }
        format.json { render json: @action_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /action_logs/1
  # PUT /action_logs/1.json
  def update
    @action_log = ActionLog.find(params[:id])

    respond_to do |format|
      if @action_log.update_attributes(params[:action_log])
        format.html { redirect_to @action_log, notice: 'Action log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @action_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /action_logs/1
  # DELETE /action_logs/1.json
  def destroy
    @action_log = ActionLog.find(params[:id])
    @action_log.destroy

    respond_to do |format|
      format.html { redirect_to action_logs_url }
      format.json { head :no_content }
    end
  end
end
