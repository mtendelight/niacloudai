class SendTaskRemindersDailyJob < ApplicationJob
  queue_as :default

  def perform
    tasks = Task.where(due_date: Date.tomorrow)
    tasks.find_each do |task|
      SendTaskReminderJob.perform_later(task)
    end
  end
end
