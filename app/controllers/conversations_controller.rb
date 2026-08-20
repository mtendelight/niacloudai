class ConversationsController < ApplicationController
  before_action :set_users, only: [:new, :create]
  before_action :set_conversation, only: [:show, :destroy]

def index
@today_tasks = current_user.daily_tasks
                           .where.not(status: "completed")
                           .order(position: :asc, created_at: :desc)

                           # Normalize positions
@today_tasks.each_with_index do |task, index|
  task.update_column(:position, index + 1) if task.position != index + 1
  task.position = index + 1
end

  @conversations = Conversation
                     .includes(:sender, :recipient)
                     .left_joins(:messages)
                     .joins("LEFT JOIN users AS senders ON senders.id = conversations.sender_id")
                     .joins("LEFT JOIN users AS recipients ON recipients.id = conversations.recipient_id")
                     .where("conversations.sender_id = :id OR conversations.recipient_id = :id",
                            id: current_user.id)
                     .distinct
                     .order(updated_at: :desc)

  if params[:query].present?
    q = "%#{params[:query].strip}%"

    # Search Daily Tasks
    @today_tasks = @today_tasks.where(
      "LOWER(title) LIKE LOWER(:q)
       OR LOWER(notes) LIKE LOWER(:q)",
      q: q
    )

    # Search Conversations
    @conversations = @conversations.where(
      "LOWER(senders.username) LIKE LOWER(:q)
       OR LOWER(recipients.username) LIKE LOWER(:q)
       OR LOWER(messages.content) LIKE LOWER(:q)
       OR LOWER(conversations.title) LIKE LOWER(:q)",
      q: q
    ).distinct
  end
end


def move_up
  task = current_user.daily_tasks.find(params[:id])

  previous = current_user.daily_tasks
                         .where("position < ?", task.position)
                         .order(position: :desc)
                         .first

  if previous
    task.position, previous.position = previous.position, task.position
    task.save!
    previous.save!
  end

  redirect_back fallback_location: conversations_path
end

def move_down
  task = current_user.daily_tasks.find(params[:id])

  nxt = current_user.daily_tasks
                    .where("position > ?", task.position)
                    .order(position: :asc)
                    .first

  if nxt
    task.position, nxt.position = nxt.position, task.position
    task.save!
    nxt.save!
  end

  redirect_back fallback_location: conversations_path
end

def destroy
  @conversation = current_user.conversations.find(params[:id])
  @conversation.destroy

  redirect_to conversations_path, notice: "Conversation deleted."
end

def messages
  @conversation = current_user.conversations.find(params[:id])

  @messages = @conversation.messages
                           .includes(:user, :reply_to)
                           .order(created_at: :asc)

  render partial: "messages/message",
         collection: @messages,
         as: :message,
         locals: { conversation: @conversation }
end

  def new
    @conversation = Conversation.new
  end

def show
  @conversation = current_user.conversations.find(params[:id])

  @messages = @conversation.messages
                           .includes(:user, :reply_to)
                           .order(:created_at)

  @message = @conversation.messages.build
end

  def create
    recipient = User.find(conversation_params[:recipient_id])

    existing = Conversation.between(current_user, recipient).first

    if existing
      redirect_to conversation_messages_path(existing)
      return
    end

    @conversation = Conversation.new(conversation_params)
    @conversation.sender = current_user

    if @conversation.save
      redirect_to conversation_messages_path(@conversation)
    else
      render :new
    end
  end

  private

  def set_users
    @users = User.where.not(id: current_user.id)
  end

  def conversation_params
    params.require(:conversation).permit(:recipient_id, :title)
  end

  def set_conversation
  @conversation = current_user.conversations.find(params[:id])
end
end