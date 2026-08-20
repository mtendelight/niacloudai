# lib/tasks/logs.rake
namespace :logs do
  desc "Clean old request logs"
  task clean: :environment do
    RequestLog.where("created_at < ?", 7.days.ago).delete_all
    puts "Old logs cleaned"
  end
end