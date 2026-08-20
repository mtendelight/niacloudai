class DailyTaskMailer < ApplicationMailer
  default from: "Flow <noreply@momak.co.ke>"

  def reminder(emails, username, task, reminder)
    @username = username
    @task = task
    @reminder = reminder

    mail(
      to: emails,
      subject: "#{reminder} #{task.title}"
    )
  end
end