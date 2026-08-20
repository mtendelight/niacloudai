class ImportCdrJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    Rails.logger.info "===================================="
    Rails.logger.info "🚀 ImportCdrJob STARTED"
    Rails.logger.info "📄 File: #{file_path}"
    Rails.logger.info "===================================="

    unless File.exist?(file_path)
      Rails.logger.error "❌ File does not exist!"
      return
    end

    Rails.logger.info "✅ File exists"

    Janomaxlead.import(file_path)

    Rails.logger.info "✅ Janomaxlead.import completed"

    File.delete(file_path)

    Rails.logger.info "🗑 Temporary file deleted"
    Rails.logger.info "🎉 Import completed successfully"

  rescue => e
    Rails.logger.error "===================================="
    Rails.logger.error "❌ IMPORT FAILED"
    Rails.logger.error e.class.name
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    Rails.logger.error "===================================="
  end
end