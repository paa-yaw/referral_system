class Admin::MessagesController < Admin::ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :send_message]	
  layout "admin"


  def index
  	@messages = Message.all.order(created_at: :asc)
  end

  def show
    set_reply_thread @message
  end

  def new
  	@message = current_user.messages.build
    
    if request.referrer == admin_messages_url
      session[:from_messages_index] = request.referrer  
    else  
      @reply_id = params[:reply_id].to_i
      @reply_message = Message.find(@reply_id) 
      @recipient_id = @reply_message.recipient_id
      @recipient_email = User.find(@recipient_id).email 
      set_reply_thread @reply_message
    end
  end

  def create
  	@message = current_user.messages.build(message_params) 
    
    if session[:from_messages_index] == params[:message][:from_messages_index]
    else

      # refactor this piece of code 
      @message.reply_id = params[:message][:reply_id]
      @message.title = params[:message][:title] 
      @message.recipient_name = params[:message][:recipient_name]
      @message.recipient_id = params[:message][:recipient_id]
      @message.user_id = params[:message][:user_id]
      @message.sent_by = params[:message][:sent_by]
      @reply_message = Message.find(@message.reply_id.to_i) if params[:message][:reply_id]
    end

  	find_recipient(@message) if @reply_message.nil?

  	if @message.save
  	  flash[:success] = "successfully sent #{@message.recipient_name}"
  	  redirect_to admin_messages_url	
  	else 	
  	  flash[:alert] = "oops! sthg went wrong"

      # refactor this piece of code
      @message.reply_id = params[:message][:reply_id]
      @message.title = params[:message][:title] 
      @message.recipient_name = params[:message][:recipient_name]
      @message.recipient_id = params[:message][:recipient_id]
      @message.user_id = params[:message][:user_id]
      @message.sent_by = params[:message][:sent_by]
      @reply_message = Message.find(@message.reply_id.to_i) if params[:message][:reply_id]
      set_reply_thread @reply_message

  	  render :new	
  	end  	
  end

  def edit
  end

  def update
  	if @message.update(message_params)
  	  flash[:success] = "successfully updated message"

  	  if request.referrer == edit_admin_message_url(@message, page: "from show")
  	  	redirect_to [:admin, @message]
  	  else
  	    redirect_to admin_messages_url
  	  end	
  	else
  	  flash[:alert] = "oops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@message.destroy
  	redirect_to admin_messages_url
  end

  def send_message
    @message.update(draft: false)
    redirect_to admin_messages_url
  end


  private 

  def message_params
  	params.require(:message).permit(:recipient_name, :content, :read, :title, :user_id, :recipient_id, :draft, :sent_by)
  end

  def find_recipient(message)
    user = User.find_by fullname: message.recipient_name
    recipient_id = user.id if user
    message.recipient_id = recipient_id
    message.sent_by = current_user.fullname << "(Admin)"
    @message = message
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_reply_thread(message)
     @reply_thread = []
    Message.where(recipient_id: current_user.id, user_id: message.user_id).each do |msg|
      @reply_thread << msg
    end
    Message.where(recipient_id: message.user_id, user_id: current_user.id).each do |msg|
      @reply_thread << msg
    end
    @reply_thread.sort! { |a, b| b.created_at <=> a.created_at }
  end
end
