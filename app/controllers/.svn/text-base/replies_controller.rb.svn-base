class RepliesController < ApplicationController
  layout "contents/common.html.erb"
  #ログインを必要としない
  skip_before_filter :login_required
  
  # GET /replies
  # GET /replies.xml
  def index
#    @replies = Reply.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#     
#    end
  end

  # GET /replies/1
  # GET /replies/1.xml
  def show
    @reply = Reply.find(local_session[:id])

    respond_to do |format|
      format.html # show.html.erb
     
    end
  end

  # GET /replies/new
  # GET /replies/new.xml
  def new
    @reply = Reply.new
    if params[:entry_id]
      now = Time.now
      entry = Entry.where( Entry.sql_valid_article , now, now, now).where( :id =>  params[:entry_id]).first
     @reply.title = entry.title 
   end
   
   form = Form.where("template_name =?", params[:name]).first
 @reply.form_id = form.id

    respond_to do |format|
      format.html # new.html.erb
     
    end
  end

  # GET /replies/1/edit
  def edit
    @reply = Reply.find(local_session[:id])
  end

  # POST /replies
  # POST /replies.xml
  def create
    @reply = Reply.new(params[:reply])

    respond_to do |format|
      if @reply.save
        local_session[:id] = @reply.id
        #format.html { redirect_to(@reply, :notice => 'Reply was successfully created.') }
        format.html { render :action => "show"  }
        
      else
        format.html { render :action => "new" }
        
      end
    end
  end

  # PUT /replies/1
  # PUT /replies/1.xml
  def update
    @reply = Reply.find(local_session[:id])

    respond_to do |format|
      if @reply.update_attributes(params[:reply])
        #format.html { redirect_to(@reply, :notice => 'Reply was successfully updated.') }
        format.html {
          if params[:button_send]
              UserMailer.hikae_email("foo").deliver
              render :template => 'replies/sent.html.erb'
          else
              render :action => "show"   
          end
        }
      else
        format.html { render :action => "edit" }
        
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.xml
  def destroy
    @reply = Reply.find(local_session[:id])
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to(replies_url) }
      
    end
  end
  
  private
#  def save_form
#    local_session[:form] = @reply
#    
#  end
#  
#  def find_form
#    local_session[:form]
#  end
  
  
  #このコントローラ内部だけで使うセッションを返す
  def local_session
    session[:replies_controller] ||= {  }
  end   
end
