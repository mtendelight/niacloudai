# config/initializers/security_headers.rb
Rails.application.config.action_dispatch.default_headers.merge!({
  'X-XSS-Protection' => '0'
})
