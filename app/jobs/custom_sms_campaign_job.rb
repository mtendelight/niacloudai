
class CustomSmsCampaignJob < ApplicationJob
  queue_as :default

  def perform(recipient_type, message)

    sms_service = TextsmsService.new(
      api_key: "07f5a8a2cbf54a4bb8cd42eff0b28ece",
      partner_id: "14784",
      shortcode: "JANOMAX"
    )

    sent   = 0
    failed = 0

    ############################################
    # CUSTOMERS
    # Jmcustomer
    ############################################
    if ["customers", "all"].include?(recipient_type)

      Jmcustomer
        .where.not(phone: [nil, ""])
        .find_each do |customer|

        sms = message.to_s
                    .gsub("{name}", customer.name.to_s.presence || "Customer")
                    .gsub("{points}", customer.points.to_s)
                    .gsub("{location}", customer.location.to_s)

        sms += "\n\n- Janomax Premium Bales"

        begin
          sms_service.send_sms(customer.phone, sms)

          sent += 1

          Rails.logger.info(
            "✅ SMS sent to Customer: #{customer.name} (#{customer.phone})"
          )

        rescue => e

          failed += 1

          Rails.logger.error(
            "❌ Customer #{customer.id} (#{customer.phone}): #{e.message}"
          )
        end

        sleep 0.3
      end
    end


    ############################################
    # CALL CENTER LEADS
    # Janomaxlead
    # /janomaxleads?status=open
    ############################################
    if ["call_center_leads", "all"].include?(recipient_type)

      Janomaxlead
        .where(lead_status: "open")
        .where.not(phone: [nil, ""])
        .find_each do |lead|

        sms = message.to_s
                    .gsub(
                      "{name}",
                      lead.name.to_s.presence || "Customer"
                    )
                    .gsub("{points}", "")
                    .gsub("{location}", "")

        sms += "\n\n- Janomax Premium Bales"

        begin
          sms_service.send_sms(lead.phone, sms)

          sent += 1

          Rails.logger.info(
            "✅ SMS sent to Call Center Lead: #{lead.name} (#{lead.phone})"
          )

        rescue => e

          failed += 1

          Rails.logger.error(
            "❌ Call Center Lead #{lead.id} (#{lead.phone}): #{e.message}"
          )
        end

        sleep 0.3
      end
    end


    ############################################
    # WHATSAPP LEADS
    # Jmlead
    # /jmleads?filter=open
    #
    # IMPORTANT:
    # Jmlead uses `status`, NOT `filter`
    ############################################
    if ["whatsapp_leads", "all"].include?(recipient_type)

      Jmlead
        .where(status: "open")
        .where.not(phone: [nil, ""])
        .find_each do |lead|

        sms = message.to_s
                    .gsub(
                      "{name}",
                      lead.name.to_s.presence || "Customer"
                    )
                    .gsub("{points}", "")
                    .gsub("{location}", "")

        sms += "\n\n- Janomax Premium Bales"

        begin
          sms_service.send_sms(lead.phone, sms)

          sent += 1

          Rails.logger.info(
            "✅ SMS sent to WhatsApp Lead: #{lead.name} (#{lead.phone})"
          )

        rescue => e

          failed += 1

          Rails.logger.error(
            "❌ WhatsApp Lead #{lead.id} (#{lead.phone}): #{e.message}"
          )
        end

        sleep 0.3
      end
    end


    ############################################
    # FINAL LOG
    ############################################

    Rails.logger.info(
      "🎉 Custom SMS Campaign Completed. " \
      "Sent: #{sent}, " \
      "Failed: #{failed}, " \
      "Recipient Type: #{recipient_type}"
    )

  end
end
