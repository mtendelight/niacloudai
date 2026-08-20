class Ahoy::Store < Ahoy::DatabaseStore
  # You can add any custom behavior for the Ahoy::Store here
end

# Ahoy configuration settings
Ahoy.api = true
Ahoy.track_bots = true
Ahoy.visit_duration = 1.minute
Ahoy.mask_ips = true
Ahoy.cookies = :none
Ahoy.geocode = false
Ahoy.job_queue = :low_priority
# Ahoy.server_side_visits = :when_needed # Uncomment if needed
