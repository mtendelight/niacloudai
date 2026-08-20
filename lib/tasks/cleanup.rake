# lib/tasks/cleanup.rake
namespace :cleanup do
  desc "Clean up temporary files"
  task tmp: :environment do
    puts "Cleaning up temporary files..."
    FileUtils.rm_rf(Dir.glob(Rails.root.join('tmp', '*')))
    puts "Temporary files cleaned."
  end
end
