namespace :app do
  desc "Lightweight maintenance task (safe for Heroku production)"
  task maintenance: :environment do
    puts "🚀 Starting lightweight maintenance..."

    # 1. Log start time (helps debugging scheduler)
    start_time = Time.current

    # 2. Warm cache keys (optional but FAST recovery boost)
    if Rails.cache.respond_to?(:fetch)
      Rails.cache.fetch("app:maintenance:last_run", expires_in: 24.hours) do
        start_time.to_s
      end
    end

    # 3. Clear ONLY stale temp cache keys (safe)
    if Rails.cache.respond_to?(:delete_matched)
      Rails.cache.delete_matched("tmp:*")
      Rails.cache.delete_matched("cache:stale:*")
    end

    # 4. Release DB connections safely (NO churn)
    ActiveRecord::Base.connection_pool.release_connection if defined?(ActiveRecord::Base)

    # 5. Optional: cleanup ActiveRecord query cache
    ActiveRecord::Base.clear_query_cache if ActiveRecord::Base.respond_to?(:clear_query_cache)

    # ❌ DO NOT DO:
    # Rails.cache.clear
    # GC.start

    duration = Time.current - start_time

    puts "✅ Maintenance completed in #{duration.round(2)}s at #{Time.current}"
  end
end