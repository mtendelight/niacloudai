# config/initializers/sidekiq.rb

require "sidekiq"
require "sidekiq-cron"
require "openssl"
require "yaml"

redis_config = {
  url: ENV.fetch("REDIS_URL"),
  ssl_params: {
    verify_mode: OpenSSL::SSL::VERIFY_NONE
  }
}

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.on(:startup) do
    schedule_file = Rails.root.join("config", "sidekiq.yml")

    if File.exist?(schedule_file)

      schedule = YAML.safe_load(
        File.read(schedule_file),
        permitted_classes: [Symbol],
        aliases: true
      )

      jobs =
        schedule["schedule"] ||
        schedule[:schedule]

      if jobs.present?
        Sidekiq::Cron::Job.load_from_hash(jobs)

        Rails.logger.info(
          "[Sidekiq] #{jobs.keys.count} cron jobs loaded successfully."
        )
      else
        Rails.logger.warn(
          "[Sidekiq] No cron jobs found in config/sidekiq.yml"
        )
      end

    else
      Rails.logger.warn(
        "[Sidekiq] config/sidekiq.yml not found."
      )
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end