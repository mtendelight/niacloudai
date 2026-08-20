class TaskMailer < ApplicationMailer
  default from: "Momak ERP <chat@momakgroup.co.ke>"

  def due_reminder(emails, username, task)
    @task = task
    @username = username

    mail(
      to: emails,
      subject: "⏰ Task Due Soon: #{@task.title}"
    )
  end
end