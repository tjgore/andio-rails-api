class MessagesController < ApplicationController
  before_action :set_message, only: [:update, :destroy]
  before_action :authenticate_request!

  # GET /messages
  def index
    @messages = Message.where("to_id = :current_user_id OR from_id = :current_user_id", {current_user_id: @current_user.id}).order("created_at ASC").all()
    
    user_ids = []
    @messages.each do |message|
      user_ids.push(message.to_id, message.from_id)
    end
    @messages = getUserFullName(user_ids, @messages)
    render json: @messages 
  end

  # GET /conversation/:id/messages
  def getConversationMessages
     @messages = Message.where("to_id = :current_user_id OR from_id = :current_user_id", {current_user_id: @current_user.id}).where("conversation_id = :conversation_id",{conversation_id: params[:id]} ).order("created_at DESC").all()

    user_ids = []
    @messages.each do |message|
      user_ids.push(message.to_id, message.from_id)
    end
    @messages = getUserFullName(user_ids, @messages)

    render json: @messages
  end

  #GET messages/unread
  def unread
    @messages = Message.all.except(:id).select('id, conversation_id, to_id, read').where(to_id: @current_user.id).where(read: 0).group('messages.conversation_id').order("created_at ASC")
     render json: @messages, status: :ok
  end


  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PUT /messages/update_read/1
  def update_read
    @read_messages = Message.where(to_id: @current_user.id).where(conversation_id: params[:id]).where(read: 0)
    if @read_messages.update_all(read: 1)
      render json: @read_messages
    else
      render json: @read_messages.errors, status: :unprocessable_entity
    end
  end 

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:conversation_id, :to_id, :from_id, :body)
    end
end
