# config/initializers/action_cable.rb

require "openssl"

ActionCable.server.config.cable = {
  adapter: "redis",
  url: ENV.fetch("REDIS_URL"),
  ssl_params: {
    verify_mode: OpenSSL::SSL::VERIFY_NONE
  }
}