require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload code on every request.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Allow ngrok domains.
  config.hosts << /[a-z0-9\-]+\.ngrok-free\.app/

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing.
  config.server_timing = true

  # --------------------------------------------------------------------------
  # Caching
  # --------------------------------------------------------------------------
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store

    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # --------------------------------------------------------------------------
  # Active Storage
  # --------------------------------------------------------------------------
  config.active_storage.service = :local

  # --------------------------------------------------------------------------
  # Action Mailer
  # --------------------------------------------------------------------------
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.default_url_options = {
    host: "portal.niaclass.co.ke"
  }

  config.action_mailer.smtp_settings = {
    address:              "mail.niaclass.co.ke",
    port:                 465,
    domain:               "niaclass.co.ke",
    user_name:            "support@niaclass.co.ke",

    # Recommended:
    # export SMTP_PASSWORD="your_password"
    password: ENV.fetch("SMTP_PASSWORD", "janomax1234Q!"),

    authentication:       :plain,
    ssl:                  true,
    enable_starttls_auto: false
  }

  # --------------------------------------------------------------------------
  # Deprecations
  # --------------------------------------------------------------------------
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # --------------------------------------------------------------------------
  # Active Record
  # --------------------------------------------------------------------------
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # --------------------------------------------------------------------------
  # Active Job
  # --------------------------------------------------------------------------
  config.active_job.verbose_enqueue_logs = true

  # --------------------------------------------------------------------------
  # Assets
  # --------------------------------------------------------------------------
  config.assets.quiet = true

  # --------------------------------------------------------------------------
  # Bullet (N+1 Query Detection)
  # --------------------------------------------------------------------------
  config.after_initialize do
    if defined?(Bullet)
      Bullet.enable = true

      # Browser popup
      Bullet.alert = true

      # Browser console
      Bullet.console = true

      # Rails log
      Bullet.rails_logger = true

      # Bullet log (log/bullet.log)
      Bullet.bullet_logger = true

      # HTML footer notification
      Bullet.add_footer = true

      # Raise exceptions when an N+1 query is detected.
      # Extremely useful while fixing performance issues.
      Bullet.raise = true

      # Optional extras
      Bullet.unused_eager_loading_enable = true
      Bullet.n_plus_one_query_enable = true
      Bullet.counter_cache_enable = true
    end
  end
end