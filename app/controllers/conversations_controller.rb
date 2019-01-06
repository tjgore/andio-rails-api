class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :update, :destroy]
  before_action :authenticate_request!

  # GET /conversations
  # Get all current user conversation ids
  def index
    @conversations = Conversation.where("to_id = :current_user_id OR from_id = :current_user_id", {current_user_id: @current_user.id}).joins(:messages).group('messages.id, messages.conversation_id').take(10).as_json
    
    convos = []
    @conversations.each do |convo|
      convos.push(convo["id"])
    end

    @conversations_requests = ConversationsRequest.where(conversation_id: convos)

    @conversations.each_with_index do |conversation, index|
      @conversations_requests.each do |convo_request|
        if(conversation["id"] == convo_request.conversation_id)
          @conversations[index]["request_id"] = convo_request.request_id
        end
      end
    end

    render json: @conversations
  end

  # GET /conversations/1
  def show
    render json: @conversation
  end

  # POST /conversations
  def create

    #conversation_params 
    if userConvoRequestExists(params)
      return
    end

    @conversation = Conversation.new(subject: params[:conversation][:subject])
 
   if @conversation.save
      @conversations_request = ConversationsRequest.new(conversation_id: @conversation.id, request_id: params[:conversation][:request_id])

      if !@conversations_request.save
        render json: @conversation_request.errors, status: :unprocessable_entity
      end
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end

    @message = Message.new(conversation_id: @conversation.id, to_id: params[:conversation][:to_id], from_id: @current_user.id, body: params[:conversation][:body])

    if @message.save
      render json: {conversation: @conversation, message: @message}, status: :created, location: @conversation
    else
      render json: @message.errors, status: :unprocessable_entity
    end

    addCountToRequest
  end

  def addCountToRequest
    @request = Request.find(params[:conversation][:request_id])
    if (@request.start_count == 4)
      @request.update(start_count: @request.start_count + 1, start_date: Time.now, active: 0)
    else
      @request.update(start_count: @request.start_count + 1, start_date: Time.now)
    end
  end


  def userConvoRequestExists(params)
    @conversation_ids = Message.select('conversation_id').where("to_id = :current_user_id OR from_id = :current_user_id", {current_user_id: @current_user.id}).joins("INNER JOIN conversations_requests ON conversations_requests.conversation_id = messages.conversation_id").where(conversations_requests: {request_id: params[:conversation][:request_id]})
    
    if @conversation_ids.length > 0
      @message = Message.new(conversation_id: @conversation_ids[0].conversation_id, to_id: params[:conversation][:to_id], from_id: @current_user.id, body: params[:conversation][:body])
      if @message.save
        render json: {message: @message}, status: :created, location: @message
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end
  end

  # Patch/put /conversation/:convo_id/message to add a message
  #json convo { to_id: , body: }

  # PATCH/PUT /conversations/1
  def update
    if @conversation.update(conversation_params)
      render json: @conversation
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /conversations/1
  def destroy
    @conversation.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:request_id, :subject, :to_id, :body)
    end
  end
