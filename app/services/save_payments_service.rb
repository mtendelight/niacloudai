# app/services/save_payments_service.rb

class SavePaymentsService
  def initialize(rows)
    @rows = rows
  end

  def call
    save_payments(@rows)
  end

  private

  def save_payments(rows)
    results = { saved: 0, duplicates: 0, failed: 0, total: rows.size }

    rows.each do |row|
      begin
        phone = normalize_phone(row[:phone])
        next if phone.blank?

        # =========================
        # CUSTOMER (UPSERT)
        # =========================
        customer = Jmcustomer.find_or_initialize_by(phone: phone)

        customer.assign_attributes(
          name: extract_name(row[:raw]).presence || customer.name || "Walk-in Customer",
          location: customer.location.presence || "Unknown",
          imported: true
        )

        if customer.new_record?
          customer.points ||= 0
          customer.is_importing = true
        end

        customer.save!

        if customer.jmlead_id.nil?
          begin
            customer.convert_matching_lead
          rescue => e
            Rails.logger.warn "Lead conversion skipped: #{e.message}"
          end
        end

        # =========================
        # PAYMENT (UPSERT)
        # =========================
        ref = row[:ref].to_s.strip
        ref = nil if ref.blank?

        payment = if ref.present?
                    Jmpayment.find_or_initialize_by(transaction_ref: ref)
                  else
                    Jmpayment.new
                  end

        is_new_payment = payment.new_record?

        payment.assign_attributes(
          jmcustomer: customer,
          transaction_ref: ref,
          name: extract_name(row[:raw]),
          amount: row[:amount],
          date: parse_date(row[:date]),
          mpesa_number: phone,
          mpesa_code: extract_mpesa_code(row[:raw])
        )

        payment.save! if ref.present?

        results[:saved] += 1 if is_new_payment
        results[:duplicates] += 1 unless is_new_payment

        # =========================
        # FULFILLMENT
        # =========================
        next if ref.blank?

        fulfillment = Jfulfillment.where(
          jmcustomer_id: customer.id,
          transaction_ref: ref
        ).first_or_initialize

        if fulfillment.persisted? && fulfillment.status != "Pending"
          Rails.logger.info("Skipping fulfillment update (already processed)")
          next
        end

        fulfillment.assign_attributes(
          name: customer.name,
          phone: customer.phone,
          location: customer.location.presence || "Unknown",
          feedback: customer.feedback,
          comments: customer.comments
        )

        fulfillment.items ||= row[:raw].presence || "Imported Payment"
        fulfillment.status ||= "Pending"

        fulfillment.save!

      rescue => e
        Rails.logger.error "🔥 ERROR: #{e.message}"
        Rails.logger.error "ROW: #{row.inspect}"
        results[:failed] += 1
      end
    end

    results
  end

  # =========================
  # HELPERS
  # =========================

  def normalize_phone(phone)
    Jmpayment.send(:normalize_phone, phone)
  rescue
    phone.to_s.strip
  end

  def parse_date(date)
    Jmpayment.send(:parse_date, date)
  rescue
    date
  end

  def extract_name(text)
    Jmpayment.send(:extract_name, text)
  rescue
    nil
  end

  def extract_mpesa_code(text)
    Jmpayment.send(:extract_mpesa_code, text)
  rescue
    nil
  end
end