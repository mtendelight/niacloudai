# lib/tasks/clear_sessions.rake
namespace :tmp do
  desc "Clean session files"
  task clean_sessions: :environment do
    session_path = Rails.root.join('tmp', 'sessions')
    FileUtils.rm_rf(Dir.glob("#{session_path}/**/*"))
    puts "Session files cleaned."
  end
end
