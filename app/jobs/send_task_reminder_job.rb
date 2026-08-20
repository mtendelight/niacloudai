class SendTaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task)
    TaskMailer.due_date_reminder(task).deliver_now
  end
end
