class Ailog < ApplicationRecord

  belongs_to :aicustomer, optional: true

  def jmlead
    normalized_phone = Jmlead.normalize_phone(phone)

    Jmlead.find_by(phone: normalized_phone)
  end

  default_scope { order(received_at: :desc) }


  def self.to_csv(records)
    CSV.generate(headers: true) do |csv|
      csv << [
        "Received At",
        "Customer",
        "Phone",
        "Message"
      ]

      records.find_each do |log|
        csv << [
          log.received_at,
          log.customer_name,
          log.phone,
          log.message
        ]
      end
    end
  end

end