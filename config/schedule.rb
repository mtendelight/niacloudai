# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every 1.day, at: '12:00 am' do
  runner "Task.where('due_date = ?', Date.today + 1).find_each do |task| SendTaskReminderJob.perform_later(task.id) end"
end

# config/schedule.rb
# config/schedule.rb
every 30.minutes do
  runner "TrendFetcher.call"
end
