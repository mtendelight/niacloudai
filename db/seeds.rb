# db/seeds.rb

puts "🌱 Starting NiaCloud seed..."

# ============================================================
# SUPERADMIN USER
# ============================================================

admin_email    = "admin@niacloud.co.ke"
admin_username = "admin"
admin_password = "janomax"

user = User.find_or_initialize_by(email: admin_email)

# ============================================================
# AUTHENTICATION
# ============================================================

user.username = admin_username if user.respond_to?(:username=)

user.password = admin_password
user.password_confirmation = admin_password

# ============================================================
# DEVISE CONFIRMATION
# ============================================================

if user.respond_to?(:confirmed_at=)
  user.confirmed_at = Time.current
end

# ============================================================
# USER DETAILS
# ============================================================

user.phone_number = "0700000000" if user.respond_to?(:phone_number=)
user.country_code = "+254" if user.respond_to?(:country_code=)

# ============================================================
# ACCOUNT STATUS
# ============================================================

user.status = "active" if user.respond_to?(:status=)

# ============================================================
# OPTIONAL SECURITY FIELDS
# ============================================================

user.pin = "1234" if user.respond_to?(:pin=)
user.otp_enabled = false if user.respond_to?(:otp_enabled=)

# ============================================================
# SAVE USER
# ============================================================

user.save!

puts "✅ User created/updated: #{user.email}"

# ============================================================
# SUPERADMIN ROLE
# ============================================================

if user.respond_to?(:roles) && defined?(Role)

  role = Role.find_or_create_by!(name: "superadmin")

  unless user.roles.exists?(id: role.id)
    user.roles << role
  end

  puts "✅ Role assigned: superadmin"

elsif user.respond_to?(:role=)

  user.role = "superadmin"
  user.save!

  puts "✅ Role assigned: superadmin"

else

  puts "⚠️ Could not automatically assign superadmin role."

end

# ============================================================
# FINAL VERIFICATION
# ============================================================

user.reload

puts ""
puts "=============================================="
puts "✅ NiaCloud SUPERADMIN READY"
puts "=============================================="
puts "ID:            #{user.id}"
puts "Email:         #{user.email}"

if user.respond_to?(:username)
  puts "Username:      #{user.username}"
end

if user.respond_to?(:phone_number)
  puts "Phone:         #{user.phone_number}"
end

if user.respond_to?(:status)
  puts "Status:        #{user.status}"
end

if user.respond_to?(:confirmed_at)
  puts "Confirmed at:  #{user.confirmed_at}"
end

if user.respond_to?(:roles)
  puts "Roles:         #{user.roles.pluck(:name).join(', ')}"
elsif user.respond_to?(:role)
  puts "Role:          #{user.role}"
end

puts ""
puts "Login:"
puts "Email:         #{admin_email}"
puts "Password:      #{admin_password}"
puts "=============================================="
puts "🌱 Seed completed successfully."
puts "=============================================="
