class DailyTaskReminderJob < ApplicationJob
  queue_as :default

  STAFF = {
    "mtendem" => {
      phone: "254714316282",
      emails: [
        "info@momak.co.ke",
        "moses.mtende@gmail.com"
      ]
    },
    "carol" => {
      phone: "254708425968",
      emails: ["carol@momakgroup.co.ke"]
    },
    "eunice" => {
      phone: "254745673055",
      emails: ["eunice@momakgroup.co.ke"]
    },
    "vero" => {
      phone: "254797441149",
      emails: ["veronica@momakgroup.co.ke"]
    },
    "veroh" => {
      phone: "254797441149",
      emails: ["veronica@momakgroup.co.ke"]
    },
    "angela" => {
      phone: "254718615534",
      emails: ["angela@momakgroup.co.ke"]
    }
  }.freeze

  def perform
    DailyTask
      .includes(:user)
      .where.not(status: "completed")
      .where(due_date: Date.current..(Date.current + 2.days))
      .find_each do |task|

      user = task.user
      next unless user

      username = user.username.downcase
      next unless STAFF.key?(username)

      recipient = STAFF[username]

      days = (task.due_date - Date.current).to_i

      reminder =
        case days
        when 2
          "⏰ Your task is due in 2 days."
        when 1
          "⏰ Your task is due tomorrow."
        when 0
          "🚨 Your task is due today."
        end

      sms = <<~MSG
#{reminder}

📝 #{task.title}

📅 Due: #{task.due_date.strftime("%d %b %Y")}

Status: #{task.status.humanize}

Open Flow:
https://flow.momak.co.ke/conversations
MSG

      TextsmsService.new(
        api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
        partner_id: "14784",
        shortcode: "JANOMAX"
      ).send_sms(recipient[:phone], sms)

      DailyTaskMailer.reminder(
        recipient[:emails],
        user.username.titleize,
        task,
        reminder
      ).deliver_later
    end
  end
end