class MessagesController < ApplicationController
  before_action :set_conversation
 

 def index
  @messages = @conversation.messages
                         .includes(:user, :reply_to)
                         .order(created_at: :asc)

  # Mark messages as read (ONLY messages not sent by current user)
  @conversation.messages
               .where.not(user_id: current_user.id)
               .where(read_at: nil)
               .update_all(read_at: Time.current)


end




def destroy
  @conversation = Conversation.find(params[:conversation_id])

  @message = @conversation.messages.find(params[:id])

  authorize = @message.user == current_user

  unless authorize
    redirect_back fallback_location: conversation_messages_path(@conversation),
                  alert: "Not allowed"
    return
  end

  @message.destroy

  redirect_to conversation_messages_path(@conversation),
              notice: "Message deleted."
end

def create
  @message = @conversation.messages.new(message_params)
  @message.user = current_user

  if params[:message][:attachment].present?
    @message.attachment_filename =
      params[:message][:attachment].original_filename
  end

if @message.save
  AiReplyJob.perform_later(@message.id) if ai_conversation?

  redirect_to conversation_messages_path(@conversation)
  else
    @messages = @conversation.messages
                             .includes(:user, :reply_to)
                             .order(:created_at)

    render :index, status: :unprocessable_entity
  end
end


private

def ai_conversation?
  @conversation.sender.username.to_s.downcase == "janomaxai" ||
    @conversation.recipient.username.to_s.downcase == "janomaxai"
end

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

def message_params
  params.require(:message)
        .permit(
          :content,
          :reply_to_id,
          :attachment,
          :attachment_filename
        )
end
end