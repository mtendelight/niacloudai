Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 'soccerstar-387416', 'AIzaSyBlKyYxM8bmfGPNak677ULku3NIdJWHM5g', {
    skip_jwt: true,
    prompt: 'select_account',
    hd: 'your_domain.com' # Optional: Restrict authentication to a specific domain
  }
end