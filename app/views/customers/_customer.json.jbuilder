json.extract! customer, :id, :name, :phone, :alternative_phone, :email, :payment_duration, :payment_amount, :payment_date, :created_at, :updated_at
json.url customer_url(customer, format: :json)
