Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure = true # This is recommended for most cases
  config.cdn_subdomain = true # Depending on your Cloudinary account configuration
end
