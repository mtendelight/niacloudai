require_relative "boot"
#require 'dotenv/load' if Rails.env.development? || Rails.env.test?
require "rails/all"
#require 'pdf-reader'
require 'open-uri'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Oj.optimize_rails
module Flow
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.middleware.use Rack::Brotli
    config.autoload_paths += %W(#{config.root}/app/pdf_generators)
    config.assets.initialize_on_precompile = false
     config.autoload_paths += %W(#{config.root}/app/middleware)
     config.autoload_paths << Rails.root.join('app/pdfs')
   config.assets.precompile += %w( flogo.png )
    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, BigDecimal]
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
    require 'dotenv/load' if Rails.env.development? || Rails.env.test?
      config.action_dispatch.default_headers.merge!({
      'X-XSS-Protection' => '0'
    })

         config.action_dispatch.default_headers.merge!({
      'Content-Security-Policy' => "default-src 'self' *; script-src 'self' 'unsafe-inline' *; style-src 'self' 'unsafe-inline' *;",
      'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
      'X-Content-Type-Options' => 'nosniff',
      'X-Frame-Options' => 'DENY',
      'X-XSS-Protection' => '1; mode=block'
    })
    #config.active_job.queue_adapter = :sidekiq
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
 config.time_zone = "Africa/Nairobi"
config.active_record.default_timezone = :utc
      config.active_record.use_yaml_unsafe_load = true
      config.active_job.queue_adapter = :sidekiq

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
