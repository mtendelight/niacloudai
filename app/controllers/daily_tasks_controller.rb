class DailyTasksController < ApplicationController
  before_action :set_daily_task, only: %i[update destroy]

def index
  @today_tasks = current_user.daily_tasks
                             .today
                             .where.not(status: "completed")
                             .order(created_at: :asc)
end

def reorder
  params[:ids].each_with_index do |id, index|
    current_user.daily_tasks
                .find(id)
                .update_column(:position, index + 1)
  end

  head :ok
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

def create
  @daily_task = current_user.daily_tasks.new(daily_task_params)
  @daily_task.task_date ||= Date.current

  if @daily_task.save
    redirect_to conversations_path
  else
    @today_tasks = current_user.daily_tasks.today
    render :index, status: :unprocessable_entity
  end
end

def update
  @daily_task = current_user.daily_tasks.find(params[:id])

  old_position = @daily_task.position
  new_position = daily_task_params[:position].to_i

  DailyTask.transaction do
    if new_position != old_position
      max_position = current_user.daily_tasks.count
      new_position = [[new_position, 1].max, max_position].min

      if new_position < old_position
        current_user.daily_tasks
                    .where(position: new_position...old_position)
                    .update_all("position = position + 1")
      elsif new_position > old_position
        current_user.daily_tasks
                    .where(position: (old_position + 1)..new_position)
                    .update_all("position = position - 1")
      end

      @daily_task.position = new_position
    end

    @daily_task.update!(daily_task_params.except(:position).merge(position: @daily_task.position))
  end

  redirect_back fallback_location: conversations_path, notice: "Task updated."
end

  def destroy
    @daily_task.destroy
    redirect_to conversations_path
  end

  private

 def set_daily_task
  @daily_task = current_user.daily_tasks.find(params[:id])
end
  def daily_task_params
    params.require(:daily_task).permit(:task_date, :title, :notes, :status,  :position, :due_date)
  end
end