# app/jobs/clear_cache_job.rb

class ClearCacheJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "[Cache] Clearing Rails cache..."

    Rails.cache.clear

    Rails.logger.info "[Cache] Cache cleared successfully."
  end
end