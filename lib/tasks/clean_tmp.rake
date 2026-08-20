namespace :tmp do
  desc "Clean temporary files"
  task :clean do
    tmp_path = Rails.root.join('tmp')
    FileUtils.rm_rf(Dir.glob("#{tmp_path}/*"))
    puts "Temporary files cleaned."
  end
end
